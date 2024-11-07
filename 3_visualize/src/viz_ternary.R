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
    scale_fill_identity()+
    theme_void()
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
