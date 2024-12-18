viz_wq_bars <- function(in_df,
                        region,
                        color_scheme,
                        fonts,
                        png_out,
                        width,
                        height){
  
  plot_df <- in_df |> filter(aggregion_nam == region)
  # stacked bar
  (bar_plot <- ggplot(data = plot_df, 
                      aes(x = region_nam, y = total_load, color = category)) +
     geom_bar(stat = "identity", position = "stack") +
     ggtitle(region) 
     
  )
  
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300)
  
  return(png_out)
}

map_wq <- function(in_sf, nutrient, regions_sf, color_scheme,
                   width, height, png_out){
  
  load_column <- sym(ifelse(nutrient == "tn", "tn_load", "tp_load"))
  
  plot_sf <- in_sf |>
    rename(load = !!load_column)
  
  if(nutrient == "tn") {
    breaks <- c(100, 500, 1000, 2000, 3000, 6000, 12000, 30000, 120000, Inf)
  } else {
    breaks <- c(10, 40, 85, 160, 290, 520, 100, 2500, 10000, Inf)
  }
  
  n_breaks <- 10
  
  # plot_sf <- in_sf |> 
  #   filter(!is.na(!!load_column)) |> 
  #   mutate(load_level = case_when(
  #     !!load_column <= quantile(!!load_column, probs = 0.20) ~ "Very low",
  #     !!load_column <= quantile(!!load_column, probs = 0.40) ~ "Low", 
  #     !!load_column <= quantile(!!load_column, probs = 0.60) ~ "Moderate",
  #     !!load_column <= quantile(!!load_column, probs = 0.80) ~ "High",
  #     !!load_column <= quantile(!!load_column, probs = 1.00) ~ "Very high"
  #   ),
  #   load_levelf = factor(load_level, levels = c("Very high", "High",
  #                                               "Moderate", "Low", "Very low")))
  
  pretty_labels <- function(num) {
    dplyr::case_when(
      num >= 1000000 ~ format(num, scientific = TRUE),
      num >= 10000 ~ format(num, scientific = FALSE, big.mark = ","),
      num < 10000 ~ as.character(num)
    )
  }
  
  map <- ggplot(plot_sf) +
    geom_sf(
      data = regions_sf,
      fill = "transparent",
      color = "white",
      linewidth = 0.4
    ) + 
    geom_sf(aes(fill = load), color = "NA", size = 0) +
    ggplot2::binned_scale(
      aesthetics = "fill",
      palette = \(x) scico::scico(n_breaks, palette = "acton", direction = -1),
      breaks = breaks,
      labels = ~ pretty_labels(.x),
      guide = ggplot2::guide_colorsteps(
        direction = "horizontal",
        title.position = "left",
        barwidth = grid::unit((width * 3 / 4), units = "in"),
        barheight = grid::unit(0.1, units = "in"),
        label.vjust = 2
      )
    ) +
    theme_void() +
    theme(
      legend.position = "bottom") 

  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}

wq_geofacet <- function(in_df, in_sf, in_states, in_geogrid, 
                        aquifer_abbr, color_scheme,
                        png_out, width, height){
  
  aquifer_label <- in_geogrid$full_name[in_geogrid$abbr == aquifer_abbr]
  
  
  #### process data for plotting
  plot_df <- in_df |>
    mutate(bins = factor(bins, levels = c("low", "moderate", "high")))
  
  #### match projections between states and aquifers
  aquifers <- in_sf |>
    sf::st_transform(crs = sf::st_crs(in_states)) |>
    rename(full_name = LABEL) |>
    left_join(in_geogrid, by = "full_name")
  
  #### subset data for plotting focal areas
  if(aquifer_abbr != "overview") {
    # only for focal maps
    subplot_df <- plot_df |> 
      mutate(ratio = case_when(study_unit_abbreviation == aquifer_abbr ~ ratio,
                               TRUE ~ NA))
    sub_aquifers <- aquifers |> filter(abbr == aquifer_abbr)
  } else {
    subplot_df <- plot_df
  }
  
  #### select just fields that geofacet requires
  geofacet_grid_prepped <- in_geogrid |>
    rename(name = abbr) |>
    select(code, name, row, col)
  
  #### base plot with greyed out pie charts
  plot_geofacet_grey <- ggplot(data = plot_df,
         aes(x = "", y = ratio, fill = bins)) +
    geom_col(show.legend = TRUE, width = 1, color = "white", linewidth = 0.1,
             alpha = 0.5) +
    coord_polar(theta = "y", start = 0) +
    scale_fill_manual(values = c(color_scheme$low_grey, 
                                 color_scheme$mod_grey, 
                                 color_scheme$high_grey)) +
    facet_geo(~ study_unit_abbreviation, 
              grid = geofacet_grid_prepped, 
              label = "name") +
    theme_void() +
    theme(
      legend.position = "none",
      strip.text.x = element_blank()
    )
  
  plot_geofacet_color <- ggplot(data = subplot_df,
                          aes(x = "", y = ratio, fill = bins)) +
    geom_col(show.legend = TRUE, width = 1, color = "black", linewidth = 0.1) +
    geom_text(
      aes(x = 1.2,  
          label = round(ratio * 100),
          color = bins),
      position = position_stack(vjust = 0.5),
      size = 3,
      show.legend = FALSE,
      fontface = "italic"
    ) +
    coord_polar(theta = "y", start = 0) +
    scale_fill_manual(values = c(color_scheme$very_low_col, 
                                 color_scheme$moderate_col, 
                                 color_scheme$very_high_col)) +
    scale_color_manual(values = c("black", "black", "white")) +
    facet_geo(~ study_unit_abbreviation, 
              grid = geofacet_grid_prepped, 
              label = "name") +
    theme_void() +
    theme(
      legend.position = "none",
      strip.text.x = element_blank()
    )
    
  
  #### make map of states & aquifers to underlay geofacet
  if(aquifer_abbr == "overview"){
    plot_states <- ggplot(in_states) + 
      geom_sf(data = aquifers, fill = "grey90", color = "white") +
      geom_sf(fill = "transparent", color = "#d1cdc0") +
      theme_void() 
  } else {
    plot_states <- ggplot(in_states) + 
      geom_sf(data = aquifers, fill = "grey90", color = "white") +
      geom_sf(data = sub_aquifers, fill = color_scheme$high_col, 
              color = color_scheme$high_col, linewidth = 1.4) +
      geom_sf(fill = "transparent", color = "#d1cdc0") +
      theme_void() 
  }
  
  
  #### prep canvas for cowplot
  canvas <- grid::rectGrob(     
    x = 0, y = 0,     
    width = width, height = height,
    gp = grid::gpar(fill = "transparent", alpha = 1, col = "transparent"))
  
  #### Final plot
  out_plot <- 
    # set up composition
    ggdraw(ylim = c(0,1), xlim = c(0,1)) +     
    # add canvas background     
    draw_grob(canvas, x = 0, y = 1, height = height, width = width, hjust = 0, vjust = 1) +  
    # add states map     
    draw_plot(plot_states, x = 0, y = 0, width = 1) +
    # add geofacetted plot
    draw_plot(plot_geofacet_grey, x = 0, y = 0.1, height = 0.75) +
    draw_plot(plot_geofacet_color, x = 0, y = 0.1, height = 0.75) +
    # add label
    draw_label(aquifer_label, x = 0.05, y = 0.95, hjust = 0, size = 12)
  
  ggsave(plot = out_plot,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
