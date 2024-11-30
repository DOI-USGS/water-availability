map_ir <- function(in_sf,
                   in_regions,
                   color_scheme,
                   png_out,
                   width,
                   height){
  # set up color scheme
  plot_sf <- in_sf |> 
    dplyr::filter(ir_prop > 0) 
  
  
  map <- ggplot(plot_sf) +
    geom_sf(data = in_regions, 
            fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(fill = "#B0904F", aes(alpha = ir_prop),
            color = NA, size = 0)  +
    scale_alpha_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}

map_ps <- function(in_sf,
                   in_regions,
                   color_scheme,
                   png_out,
                   width,
                   height){
  # set up color scheme
  plot_sf <- in_sf |> 
    dplyr::filter(ps_prop > 0) 
  
  
  map <- ggplot(plot_sf) +
    geom_sf(data = in_regions, 
            fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(fill = "#822734", aes(alpha = ps_prop),
            color = NA, size = 0)  +
    scale_alpha_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}