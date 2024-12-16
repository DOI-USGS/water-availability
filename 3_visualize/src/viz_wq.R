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

wq_geofacet <- function(in_df, in_geogrid, png_out, width, height){
  
  plot_df <- in_df |>
    mutate(bins = factor(bins, levels = c("low", "moderate", "high")))
  
  geofacet_grid_prepped <- in_geogrid |>
    rename(name = abbreviation) |>
    select(code, name, row, col)
  
  plot_geofacet <- ggplot(data = plot_df,
         aes(x = "", y = ratio, fill = bins)) +
    geom_col(show.legend = TRUE, width = 1) +
    geom_text(
      aes(x = 1.8, fill = bins, 
          label = sprintf("%s%%", round(ratio * 100))),
      position = position_stack(vjust = 0.5),
      size = 3,
      color = "black",
      show.legend = FALSE,
      ylim = c(1, NA),
      fontface = "bold"
    ) +
    coord_polar(theta = "y", start = 0) +
    scale_fill_manual(values = c("#E7D9F2", "#8F6EB4", "#3B1E54")) +
    facet_geo(~ study_unit_abbreviation, grid = geofacet_grid_prepped, label = "name") +
    theme_void() +
    theme(
      legend.position = "none"
    )
    
  
  ggsave(plot = plot_geofacet,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
