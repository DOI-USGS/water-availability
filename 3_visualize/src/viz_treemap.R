viz_treemap <- function(in_df,
                        color_scheme,
                        png_out,
                        width,
                        height){
  
  plot_df <- in_df |> 
    mutate(svi_factor = factor(svi_category,
                               levels = c("Low SVI", 
                                          "Moderate SVI", 
                                          "High SVI")),
           sui_factor = factor(sui_category,
                               levels = c("Low SUI",
                                          "Moderate SUI",
                                          "High SUI")))
  
  #ggplot(plot_df,
  #       aes(area = n_hucs, fill = sui_factor,
  #           subgroup = sui_factor, alpha = svi_factor)) +
  #  treemapify::geom_treemap(layout = "squarified") 
  
  ggplot(plot_df,
         aes(y = proportion, x = sui_factor, fill = svi_factor)) +
    geom_bar(position = "stack", stat = "identity")
  
  
  ggsave(png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}
