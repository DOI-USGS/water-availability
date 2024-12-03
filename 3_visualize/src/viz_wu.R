map_ir <- function(in_sf,
                   in_regions,
                   color_scheme,
                   png_out,
                   width,
                   height){

  plot_sf <- in_sf |> 
    dplyr::filter(ir_prop > 0) 
  
  
  map <- ggplot(plot_sf) +
    geom_sf(data = in_regions, 
            fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(fill = color_scheme$ir_gw_main, aes(alpha = ir_prop),
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

  plot_sf <- in_sf |> 
    dplyr::filter(ps_prop > 0) 
  
  
  map <- ggplot(plot_sf) +
    geom_sf(data = in_regions, 
            fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(fill = color_scheme$ps_gw_main, aes(alpha = ps_prop),
            color = NA, size = 0)  +
    scale_alpha_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}

map_te <- function(in_sf,
                   layer,
                   in_regions,
                   color_scheme,
                   png_out,
                   width,
                   height){
  
  if(layer == "saline") {
    plot_sf <- in_sf |> 
      dplyr::select(te_saline, geometry) |>
      dplyr::filter(! is.na(te_saline)) |>
      rename(mgd = te_saline)
    
    color_dot <- color_scheme$te_saline
  } else {
    plot_sf <- in_sf |>
      dplyr::select(te_total, geometry) |>
      dplyr::filter(te_total > 0) |>
      rename(mgd = te_total)
    
    color_dot <- color_scheme$te_gw_main
  }
  
  map <- ggplot(in_regions) +
    geom_sf(fill = NA,
            color = NA, linewidth = 0.1) +
    geom_point(data = plot_sf, 
               aes(geometry = geometry),
               color = color_dot,
               stat = "sf_coordinates") +
    scale_alpha_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}