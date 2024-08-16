viz_wq_circles <- function(in_df,
                           region,
                           color_scheme,
                           fonts,
                           png_out,
                           width,
                           height){
  
  plot_df <- in_df |> 
    filter(aggregion_nam == stringr::str_replace_all(region, pattern = "_", replacement = " "))
  
  # stacked bar
  (bar_plot <- ggplot() +
     geom_bar(data = reg_part_to_whole_prop, 
              stat = "identity",
              aes(x = year, 
                  y = sum_pop, 
                  fill = sui_factor),
              width = 0.35) +
     geom_text(data = reg_part_to_whole_prop,
               aes(x = year, y = pos, label = label_pop),
               color = "black", size = 3,
               hjust = 1, nudge_x = -0.23) +
     geom_text(data = reg_part_to_whole_prop,
               aes(x = year, y = pos, label = sui_factor),
               color = "black", size = 3,
               hjust = 0, nudge_x = 0.21)+
     scale_fill_manual(values = col_pal, 
                       breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"))+
     ylim(c(0, total_bar_height + 10000)) +
     theme_void()+
     theme(legend.position = "none",
           text = element_text(family = fonts$supporting_font))
  )
  
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300)
  
  return(png_out)
}
