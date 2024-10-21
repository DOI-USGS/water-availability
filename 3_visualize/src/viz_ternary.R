ternary_map <- function(in_sf, 
                        width, height,
                        png_out){
  states <- map_data("state")
  
  ggplot(in_sf) +
    geom_sf(aes(fill = color), color = NA) +
    geom_polygon(data = states, aes(x = long, y = lat), fill = NA, color = "white") +
    scale_fill_identity() +
    theme_void()
  
  ggsave(png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
  
}
