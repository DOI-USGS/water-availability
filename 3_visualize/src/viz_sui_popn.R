viz_popn_circles <- function(in_df,
                             color_scheme,
                             png_out,
                             width,
                             height){
  
  # process data for circle packing
  in_df <- in_df |> arrange(-mean_sui, AggRegion_nam)
  packing <- packcircles::circleProgressiveLayout(in_df$popn, 
                                                  sizetype = "area")
  circle_pack_data <- cbind(in_df, packing)
  dat.gg <- packcircles::circleLayoutVertices(packing, npoints = 50)
  dat.gg$value <- rep(in_df$sui_category_5, each = 51)
  
  plot_data <- dat.gg
  
  # circle packing plot
  (circle_plot <- ggplot() + 
      geom_polygon(data = dat.gg, 
                   aes(x, y, group = id, fill = as.factor(value)), 
                   linewidth = 0.1,
                   colour = "black", alpha = 0.3) + 
      geom_polygon(data = plot_data, 
                   aes(x, y, group = id, fill = as.factor(value)), 
                   linewidth = 0.1,
                   colour = "black") + 
      scale_fill_manual(values = color_scheme, 
                        breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"), 
                        name = "Water Stress Level") +
      theme_void() + 
      theme(legend.position="none", 
            plot.margin = unit(c(1,1,1,1),"cm")) + 
      coord_equal()
  )
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300, bg = "transparent")
  
  return(png_out)
}

viz_popn_bar_vert <- function(in_df, color_scheme, fonts, direction, png_out, width, height){
  
  total_bar_height = unique(in_df$total_bar_height)

  (bar_plot <- ggplot() +
      geom_bar(data = in_df, 
               stat = "identity",
               aes(x = year, y = sum_pop, fill = sui_factor),
               width = 0.35) +
      geom_text(data = subset(in_df, label_pop %in% c("194 M", "18 M")),
                aes(x = year, y = pos, label = label_pop),
                color = "white", size = 3, hjust = 0.5) +
      geom_text(data = subset(in_df, label_pop %in% c("73 M", "26 M", "17 M")),
                aes(x = year, y = pos, label = label_pop),
                color = "black", size = 3, hjust = 0.5) +
      geom_text(data = in_df,
                aes(x = year, y = pos, label = sui_factor),
                color = "black", size = 3,
                hjust = 0, nudge_x = 0.21)+
      scale_fill_manual(values = color_scheme, 
                        breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"))+
      ylim(c(0, total_bar_height + 10000)) +
      theme_void()+
      theme(legend.position = "none",
            text = element_text(family = fonts$supporting_font))
  )

    ggsave(filename = png_out, 
           width = 2, height = 6, dpi = 300, bg = "transparent")
    
    return(png_out)
}


viz_popn_bar_hori <- function(in_df, color_scheme, fonts, direction, png_out, width, height){
  
  total_bar_height = unique(in_df$total_bar_height)
  
  plot_data <- in_df |> 
    mutate(sui_label = case_when(sui_factor == "Very low/\nnone" ~ "Very low/none", TRUE ~ sui_factor))
  
  # plot base plot and labels
  (bar_plot <- ggplot() +
      geom_bar(data = plot_data, 
               stat = "identity",
               aes(x = year, y = sum_pop, fill = sui_factor),
               width = 0.35) +
      coord_flip()+
      geom_text(data = subset(plot_data, label_pop %in% c("194 M", "18 M")),
                aes(x = year, y = pos, label = label_pop),
                color = "white", size = 2.8, hjust = 0.5) +
      geom_text(data = subset(plot_data, label_pop %in% c("73 M", "26 M", "17 M")),
                aes(x = year, y = pos, label = label_pop),
                color = "black", size = 2.8, hjust = 0.5) +
      geom_text(data = subset(plot_data, sui_label %in% c("Very low/none", "Low")),
                aes(x = year, y = pos, label = sui_label),
                color = "black", size = 3, hjust = 0.5, nudge_x = 0.35)+ 
      geom_text(data = subset(plot_data, sui_label == c("Moderate")),
                aes(x = year, y = pos, label = sui_label),
                color = "black", size = 3, hjust = 0.9, nudge_x = 0.35)+ 
      geom_text(data = subset(plot_data, sui_label == c("Severe")),
                aes(x = year, y = pos, label = sui_label),
                color = "black", size = 3, hjust = 0.1, nudge_x = 0.35)+ 
      geom_text(data = subset(plot_data, sui_label == "High"),
                aes(x = year, y = pos, label = sui_label),
                color = "black", size = 3, hjust = 0.5, nudge_x = 0.35)+ 
      scale_fill_manual(values = color_scheme, 
                        breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"))+
      ylim(c(0, total_bar_height + 10000)) +
      theme_void()+
      theme(legend.position = "none",
            text = element_text(family = fonts$supporting_font))
  )
  
  # add lines for labels
  (final_plot <- ggdraw(ylim = c(0, 1), xlim = c(0, 1)) +
      # main plot
      draw_plot(bar_plot,
                x = 0, y = 0,
                height = 1, width = 1)+
      draw_line(x = c(0.32, 0.32),
                y = c(0.655, 0.755), 
                size = 0.4) +
      draw_line(x = c(0.685, 0.685),
                y = c(0.655, 0.755), 
                size = 0.4) +
      draw_line(x = c(0.815, 0.815, 0.795),
                y = c(0.655, 0.705, 0.755), 
                size = 0.4) +
      draw_line(x = c(0.88, 0.88),
                y = c(0.655, 0.755), 
                size = 0.4) +
      draw_line(x = c(0.93, 0.93, 0.95),
                y = c(0.655, 0.705, 0.755), 
                size = 0.4) 
      )
  
  ggsave(filename = png_out, 
         width = 6, height = 2, dpi = 300, bg = "transparent")
  
  return(png_out)
}