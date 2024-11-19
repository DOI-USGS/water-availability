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

map_wq <- function(in_sf, nutrient, width, height, png_out){
  
  if(nutrient == "tn"){
    plot_sf <- in_sf |>
      filter(! is.na(tn_load)) |>
      mutate(load_level = case_when(tn_load <= quantile(tn_load, probs = 0.20) ~ "very low",
                                  tn_load <= quantile(tn_load, probs = 0.40) ~ "low", 
                                  tn_load <= quantile(tn_load, probs = 0.60) ~ "moderate",
                                  tn_load <= quantile(tn_load, probs = 0.80) ~ "high",
                                  tn_load <= quantile(tn_load, probs = 1.00) ~ "very high")) |>
      mutate(load_levelf = factor(load_level, levels = c("very high", "high", "moderate", "low", "very low")))
  } else {
    plot_sf <- in_sf |>
      filter(! is.na(tp_load)) |>
      mutate(load_level = case_when(tp_load <= quantile(tp_load, probs = 0.20) ~ "very low",
                                    tp_load <= quantile(tp_load, probs = 0.40) ~ "low", 
                                    tp_load <= quantile(tp_load, probs = 0.60) ~ "moderate",
                                    tp_load <= quantile(tp_load, probs = 0.80) ~ "high",
                                    tp_load <= quantile(tp_load, probs = 1.00) ~ "very high")) |>
      mutate(load_levelf = factor(load_level, levels = c("very high", "high", "moderate", "low", "very low")))
  }

  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = load_levelf), color = "NA", size = 0)  +
    scale_fill_manual(values = c("#552586", "#6A359C", "#804FB3", "#9969C7", "#B589D6")) +
    theme_void() 
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}
