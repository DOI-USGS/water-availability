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

map_wq <- function(in_sf, nutrient, color_scheme, regions_sf, regions_fill,
                   plot_margin, leg_title, bkgd_color, width, height, png_out){
  
  # import font
  font_legend <- 'Source Sans Pro'
  font_add_google(font_legend)
  showtext_opts(dpi = 300, regular.wt = 200, bold.wt = 700)
  showtext_auto(enable = TRUE)
  
  load_column <- sym(ifelse(nutrient == "tn", "tn_load", "tp_load"))
  
  plot_sf <- in_sf |> 
    filter(!is.na(!!load_column)) |> 
    mutate(load_level = case_when(
      !!load_column <= quantile(!!load_column, probs = 0.20) ~ "Very low",
      !!load_column <= quantile(!!load_column, probs = 0.40) ~ "Low", 
      !!load_column <= quantile(!!load_column, probs = 0.60) ~ "Moderate",
      !!load_column <= quantile(!!load_column, probs = 0.80) ~ "High",
      !!load_column <= quantile(!!load_column, probs = 1.00) ~ "Very high"
    ),
    load_levelf = factor(load_level, levels = c("Very high", "High",
                                                "Moderate", "Low", "Very low")))
  
  map <- ggplot(plot_sf) +
    geom_sf(
      data = regions_sf,
      fill = regions_fill$svg_fill_default,
      color = "white",
      linewidth = 0.4
    ) + 
    geom_sf(aes(fill = load_levelf), color = "NA", size = 0) +
    scale_fill_manual(
      values = c(
        "Very high" = color_scheme$very_high_col,
        "High" = color_scheme$high_col,
        "Moderate" = color_scheme$moderate_col,
        "Low" = color_scheme$low_col,
        "Very low" = color_scheme$very_low_col
      ),
      name = "Load Level"
    ) + 
    theme_void() +
    theme(
      legend.position = "top",
      legend.direction = "horizontal",
      legend.title = element_blank(),
      legend.text = element_blank(),
      legend.key.size = unit(0.75, "cm")) +
    guides(fill = guide_legend(reverse = TRUE))
  
  # Arrow for legend breakdown
  plot_arrow <- ggplot() +
    theme_void() +
    geom_segment(aes(x = 10, y = 5, 
                     xend = 15, yend = 5), 
                 arrow = grid::arrow(length = unit(0.5, 'lines')), 
                 color = 'black',
                 linewidth = 1)
  
  # background
  canvas <- grid::rectGrob(
    x = 0, y = 0,
    width = width, height = height,
    gp = grid::gpar(fill = bkgd_color, alpha = 1, col = "transparent")
  )
  
  # Extract from plot
  # cowplot::get_legend() was not working - this is a work around re: https://stackoverflow.com/questions/78163631/r-get-legend-from-cowplot-package-no-longer-work-for-ggplot2-version-3-5-0
  legend <- cowplot::get_plot_component(map, 'guide-box-top', return_all = TRUE)
  
  map_w_leg <- ggdraw(ylim = c(0,1),
                       xlim = c(0,1)) +
    # a background
    draw_grob(canvas,
              x = 0, y = 1,
              height = height, width = width,
              hjust = 0, vjust = 1) +
    # just nutrient map
    draw_plot(map + theme(legend.position = 'none'),
              x = 0.01,
              y = 0.02,
              height = 0.9,
              width = 0.99 - plot_margin * 2) +
    # plot arrow
    draw_plot(plot_arrow + theme(legend.position = 'none'),
              x = 0.768,
              y = 0.844,
              height = 0.025,
              width = 0.215 - plot_margin) +
    # add legend
    draw_plot(legend,
              x = 0.50,
              y = 0.69,
              height = 0.5,
              width = 0.75 - plot_margin) +
    # Legend explanation
    draw_label(leg_title,
               x = 0.777, y = 0.90,
               size = 10,
               hjust = 0,
               vjust = 1,
               color = 'black',
               fontfamily = font_legend, 
               fontface = "bold",
               lineheight = 1)
  
  ggsave(plot = map_w_leg,
         filename = png_out, device = "png", bg = bkgd_color,
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

wq_treemap <- function(in_df, useAbbr, color_scheme,
                        png_out, width, height){

  plot_df <- in_df |> filter(UseAbbr == useAbbr)
  
  # png(png_out,
  #     width = width,
  #     height = height,
  #     res = 300,
  #     units = "px")
  pdf(file = png_out,
      width = width,
      height = height)
  out_plot <- treemap(dtf = plot_df,
          index = c("Category", "Parameter"),
          vSize = "riverMiles",
          vColor = "Category",
          type = "categorical",
          border.col = "white",
          border.lwds = c(0.4,0.4),
          bg.labels = 255,
          position.legend = "none",
          palette = c(color_scheme$biotic,
                      color_scheme$metals,
                      color_scheme$nutrients,
                      color_scheme$organics,
                      color_scheme$salinity,
                      color_scheme$sediment,
                      color_scheme$temp,
                      color_scheme$unimpaired),
          fontsize.title = 0,
          fontsize.labels = 0)
  dev.off()
  
  return(png_out)
}