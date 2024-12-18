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

map_wq <- function(in_sf, nutrient, color_scheme, regions_sf, 
                   width, height, png_out){
  
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
      fill = color_scheme$svg_fill_default,
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
      legend.position = "none") 

  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
