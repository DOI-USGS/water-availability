ternary_map <- function(in_sf, tern_side,
                        color_scheme,
                        width, height,
                        png_out){
  states <- map_data("state")
  
  proc_in_sf <- in_sf |> mutate(ps_ir = case_when(category %in% c(1, 3, 4, 8, 9) ~ TRUE, .default = FALSE),
                                ps_te = case_when(category %in% c(1, 3, 2, 6, 5) ~ TRUE, .default = FALSE),
                                te_ir = case_when(category %in% c(5, 6, 7, 8, 9) ~ TRUE, .default = FALSE))
  if(tern_side != "all"){
  plot <- ggplot(proc_in_sf)+
    geom_sf(fill = color_scheme$svg_fill_default, color = color_scheme$svg_col_default)+
    geom_sf(data = subset(proc_in_sf, proc_in_sf[[tern_side]] == TRUE), aes(fill = color), color = NA)+
    geom_polygon(data = states, aes(x = long, y = lat), fill = NA, color = "white") +
    scale_fill_identity()+ #guide = "legend"
    theme_void()
    #guides(fill = guide_legend(legend.text.position = "none"))+
    #theme(legend.position = "bottom", 
    #      legend.text = element_blank()) 
    
  }
  else if(tern_side == "all"){
  plot <- ggplot(proc_in_sf) +
    geom_sf(aes(fill = color), color = NA) +
    geom_polygon(data = states, aes(x = long, y = lat), fill = NA, color = "white") +
    scale_fill_identity() +
    theme_void()
  }
  
  ggsave(png_out, plot = plot, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out) 

}

# Create colorbar legend for highlighted side of ternary plot
ternary_legend <- function(tern_side_pal, left_label, right_label, png_out){
  
  # color palette
  color_pal <- tern_side_pal
  
  # arrows for annotation
  (left_arrow <- ggplot() + 
      theme_void()+
      # add arrow using `geom_curve()`
      geom_curve(aes(x = 13, y = 1,
                     xend = 11, yend = 1),
                 arrow = grid::arrow(length = unit(0.5, 'lines')), 
                 curvature = 0, angle = 100, ncp = 10,
                 color ='black'))
  
  (right_arrow <- ggplot() + 
      theme_void()+
      # add arrow using `geom_curve()`
      geom_curve(aes(x = 11, y = 1,
                     xend = 13, yend = 1),
                 arrow = grid::arrow(length = unit(0.5, 'lines')), 
                 curvature = 0, angle = 100, ncp = 10,
                 color ='black'))
  
  # draw rectangles
  rect_plot <- function(fill){
    ggplot()+ 
      theme_void()+
      # add arrow using `geom_curve()`
      geom_rect(aes(xmin = 1, xmax = 10, ymin = 3, ymax = 7),
                color = "black", fill = fill)+
      ylim(c(0, 10))
  }
  
  rectangle_1 <- rect_plot(fill = color_pal[1,])
  rectangle_2 <- rect_plot(fill = color_pal[2,])
  rectangle_3 <- rect_plot(fill = color_pal[3,])
  rectangle_4 <- rect_plot(fill = color_pal[4,])
  rectangle_5 <- rect_plot(fill = color_pal[5,])
  
  # create cowplot
  canvas <- grid::rectGrob(
    x = 0, y = 0,
    width = 10, height = 2,
    gp = grid::gpar(fill = NULL, alpha = 0, col = NULL
    )
  )
  
  final_plot <- cowplot::ggdraw(ylim = c(0,1),
                                xlim = c(0,1)) +
    # White background
    cowplot::draw_grob(canvas,
                       x = 0, y = 1,
                       height = 2, width = 10,
                       hjust = 0, vjust = 1) +
    # Add main map
    cowplot::draw_plot(rectangle_1,
                       x = 0.037, y = 0.3,
                       height = 0.833, width = 0.2)+
    cowplot::draw_plot(rectangle_2,
                       x = 0.219, y = 0.3,
                       height = 0.833, width = 0.2)+
    cowplot::draw_plot(rectangle_3,
                       x = 0.4, y = 0.3,
                       height = 0.833, width = 0.2)+
    cowplot::draw_plot(rectangle_4,
                       x = 0.581, y = 0.3,
                       height = 0.833, width = 0.2)+
    cowplot::draw_plot(rectangle_5,
                       x = 0.763, y = 0.3,
                       height = 0.833, width = 0.2)+
    cowplot::draw_plot(left_arrow,
                       x = 0.5, y = 0.45,
                       width = 0.475,
                       hjust = 1, vjust = 0.5)+
    cowplot::draw_plot(right_arrow,
                       x = 0.5, y = 0.45,
                       width = 0.475,
                       hjust = 0, vjust = 0.5)+
    cowplot::draw_label(left_label, 
                        x = 0.05, y = 0.3,
                        size = 25, color = "black",
                        hjust = 0, vjust = 0.5)+
    cowplot::draw_label(right_label, 
                        x = 0.95, y = 0.3,
                        size = 25, color = "black",
                        hjust = 1, vjust = 0.5)
  
  ggplot2::ggsave(plot = final_plot, filename = png_out, width = 10, height = 2, dpi = 300, units = "in")
  
}

# Create ternary plot and map
ternary_plot <- function(in_df, width, height,
                         png_out){
  
  p <- ggtern::ggtern(data = in_df, aes(te_prop, ps_prop, ir_prop))
  

    p <- p +
      geom_point(aes(color = color), size = 4, alpha = 0.2) 
  
  # uses ggtern package
  p <- p + 
    geom_point(data = in_df, color = "black", size = 4, alpha = 0.8) +
    geom_point(data = in_df, color = "white", size = 3.65) +
    geom_point(data = in_df, aes(color = color), size = 3.65, alpha = 0.8) +
    scale_color_identity() +
    ggtern::limit_tern(1.05, 1.05, 1.05) +
    labs(x = "TE", y = "PS", z = "IR") +
    theme_void() +
    theme(plot.background = element_rect(fill = "transparent", color = NA),
          panel.background = element_rect(fill = "transparent", color = NA))
  
  
  ggsave(png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
