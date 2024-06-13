viz_treemap <- function(in_df,
                        in_sf,
                        chart_type, #"fill" or "stack"
                        color_scheme,
                        png_out,
                        width,
                        height){
  
  plot_df <- in_df |> 
    mutate(svi_factor = factor(svi_category,
                               levels = c("Low SVI", 
                                          "Moderate SVI", 
                                          "High SVI",
                                          "Severe SVI")),
           sui_factor = factor(sui_category,
                               levels = c("Low SUI",
                                          "Moderate SUI",
                                          "High SUI")))
  
  plot_sf <- in_sf |>
    filter( ! is.na(sui_category), ! is.na(svi_category)) |>
    mutate(join_category = sprintf("%s-%s", sui_category, svi_category))
  
  # ggplot(plot_df,
  #       aes(area = n_hucs, fill = sui_factor,
  #           subgroup = sui_factor, alpha = svi_factor)) +
  #  treemapify::geom_treemap(layout = "squarified")
  
  legend_n_hucs <- ggplot(plot_df,
         aes(y = n_hucs, x = sui_factor, fill = join_category)) +
    geom_bar(position = "stack", stat = "identity") +
    # same styles as below
    scale_fill_manual(values = c("#4c5869", "#728393",
                                 "#965a5b", "#b78985")) +
    theme_minimal() +
    theme(legend.position = "none")
  
  legend_prop_hucs <- ggplot(plot_df,
                             aes(y = n_hucs, x = sui_factor, fill = join_category)) +
    geom_bar(position = "fill", stat = "identity") +
    # same styles as above
    scale_fill_manual(values = c("#4c5869", "#728393",
                                 "#965a5b", "#b78985")) +
    theme_minimal() +
    theme(legend.position = "none")
    
  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = join_category), 
            color = NA, size = 0) +
    scale_fill_manual(values = c("#4c5869", "#728393",
                                 "#965a5b", "#b78985")) +
    theme_void() +
    theme(legend.position = "none")
    

  final_plot <- ggdraw() +
    draw_plot(map, x = 0, y = 0.1, width = 1, height = 1) +
    draw_plot(legend_prop_hucs, x = 0, y = 0.05, width = 0.25, height = 0.25) +
    draw_plot(legend_n_hucs, x = 0.5, y = 0.05, width = 0.25, height = 0.25)
    
  ggsave(plot = final_plot,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}
