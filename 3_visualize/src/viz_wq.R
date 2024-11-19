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

map_wq <- function(in_sf, nutrient, color_scheme, regions_sf, width, height, png_out){

  
  if(nutrient == "tn"){
    plot_sf <- in_sf |>
      filter(!is.na(tn_load)) |>
      mutate(load_level = case_when(tn_load <= quantile(tn_load, probs = 0.20) ~ "Very low",
                                  tn_load <= quantile(tn_load, probs = 0.40) ~ "Low", 
                                  tn_load <= quantile(tn_load, probs = 0.60) ~ "Moderate",
                                  tn_load <= quantile(tn_load, probs = 0.80) ~ "High",
                                  tn_load <= quantile(tn_load, probs = 1.00) ~ "Very high"),
             load_levelf = factor(load_level, levels = c("Very high", "High", "Moderate", "Low", "Very low")),
             color_hex = case_when(load_levelf == "Very low" ~ color_scheme$very_low_col,
                                   load_levelf == "Low" ~ color_scheme$low_col,
                                   load_levelf == "Moderate" ~ color_scheme$moderate_col,
                                   load_levelf == "High" ~ color_scheme$high_col,
                                   load_levelf == "Very high" ~ color_scheme$very_high_col))
  } else {
    plot_sf <- in_sf |>
      filter(!is.na(tp_load)) |>
      mutate(load_level = case_when(tp_load <= quantile(tp_load, probs = 0.20) ~ "Very low",
                                    tp_load <= quantile(tp_load, probs = 0.40) ~ "Low", 
                                    tp_load <= quantile(tp_load, probs = 0.60) ~ "Moderate",
                                    tp_load <= quantile(tp_load, probs = 0.80) ~ "High",
                                    tp_load <= quantile(tp_load, probs = 1.00) ~ "Very high"),
             load_levelf = factor(load_level, levels = c("Very high", "High", "Moderate", "Low", "Very low")),
             color_hex = case_when(load_levelf == "Very low" ~ color_scheme$very_low_col,
                                   load_levelf == "Low" ~ color_scheme$low_col,
                                   load_levelf == "Moderate" ~ color_scheme$moderate_col,
                                   load_levelf == "High" ~ color_scheme$high_col,
                                   load_levelf == "Very high" ~ color_scheme$very_high_col))
  }

  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = color_hex), color = "NA", size = 0) +
    geom_sf(
      data = regions_sf,
      fill = NA,
      color = "white",
      linewidth = 0.4
    ) + 
    scale_fill_identity() +
    theme_void() 
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}
