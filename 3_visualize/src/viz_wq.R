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
      legend.position = "none") 

  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}

wq_geofacet <- function(in_df, in_states, in_geogrid, png_out, width, height){
  
  plot_df <- in_df |>
    mutate(bins = factor(bins, levels = c("low", "moderate", "high")))
  
  geofacet_grid_prepped <- in_geogrid |>
    rename(name = abbr) |>
    select(code, name, row, col)
  
  plot_geofacet <- ggplot(data = plot_df,
         aes(x = "", y = ratio, fill = bins)) +
    geom_col(show.legend = TRUE, width = 1) +
    geom_text(
      aes(x = 1.8, fill = bins, 
          label = round(ratio * 100)),
      position = position_stack(vjust = 0.5),
      size = 3,
      color = "#3B1E54",
      show.legend = FALSE,
      ylim = c(1, NA),
      fontface = "italic"
    ) +
    coord_polar(theta = "y", start = 0) +
    scale_fill_manual(values = c("#E7D9F2", "#8F6EB4", "#3B1E54")) +
    facet_geo(~ study_unit_abbreviation, grid = geofacet_grid_prepped, label = "name") +
    theme_void() +
    theme(
      legend.position = "none",
      strip.text.x = element_blank()
    )
  
  plot_states <- ggplot(in_states) + 
    geom_sf(fill = "transparent", color = "#d1cdc0") +
    theme_void() 
  
  canvas <- grid::rectGrob(     
    x = 0, y = 0,     
    width = width, height = height,
    gp = grid::gpar(fill = "transparent", alpha = 1, col = "transparent"))
    
  # Function to make labels
  draw_labels <- purrr::map(1:nrow(in_geogrid), function(x){
    cowplot::draw_label(in_geogrid$full_name[x],
                        x = in_geogrid$x[x],
                        y = in_geogrid$y[x],
                        size = 10, color = "black", fontface = "bold"
    ) 
    
  })
  
  out_plot <- 
    ggdraw(ylim = c(0,1), xlim = c(0,1)) +     # a background     
    draw_grob(canvas, x = 0, y = 1, height = height, width = width, hjust = 0, vjust = 1) +     # just nutrient map     
    draw_plot(plot_states, x = 0, y = 0, width = 1) +
    draw_plot(plot_geofacet, x = 0, y = 0.1, height = 0.75) + draw_labels
  
  ggsave(plot = out_plot,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
