map_ir_or_ps <- function(in_sf,
                         layer,
                         in_regions,
                         color_scheme,
                         png_out,
                         width,
                         height){
  
  if(layer == "ir") {
    plot_sf <- in_sf |> 
      dplyr::filter(ir_prop > 0) |>
      rename(prop_use = ir_prop,
             mgd = ir_total) 
    
    mgd_values <- plot_sf$mgd
    
    plot_sf <- plot_sf |>
      mutate(alpha = case_when(mgd < quantile(mgd_values, probs = 0.25) ~ 0.1,
                               mgd < quantile(mgd_values, probs = 0.50) ~ 0.4,
                               mgd < quantile(mgd_values, probs = 0.75) ~ 0.7,
                               mgd < quantile(mgd_values, probs = 1.00) ~ 1.0)) |>
      filter(mgd > 0)
    
    color_fill = color_scheme$ir_gw_main
  } else {
    plot_sf <- in_sf |> 
      dplyr::filter(ps_prop > 0) |>
      rename(prop_use = ps_prop,
             mgd = ps_total)
    
    mgd_values <- plot_sf$mgd
    
    plot_sf <- plot_sf |>
      mutate(alpha = case_when(mgd < quantile(mgd_values, probs = 0.25) ~ 0.1,
                               mgd < quantile(mgd_values, probs = 0.50) ~ 0.4,
                               mgd < quantile(mgd_values, probs = 0.75) ~ 0.7,
                               mgd < quantile(mgd_values, probs = 1.00) ~ 1.0)) |>
      filter(mgd > 0)
    color_fill = color_scheme$ps_gw_main
  }
 
  
  map <- ggplot(in_regions) +
    geom_sf(fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(data = plot_sf, fill = color_fill, aes(alpha = alpha),
            color = NA, size = 0)  +
    scale_alpha_continuous(name = "mgd", range = c(0, 1), guide = guide_legend(label.position = "bottom")) +
    theme_void() +
    theme(legend.position = 'none')#+
    #theme(legend.position = "bottom", guide = guide_legend(label.position = "bottom"))
  
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
    geom_point(data = plot_sf, shape = 21,
               aes(geometry = geometry, size = mgd),
               color = "white", fill = "white", stroke = 0.2,
               stat = "sf_coordinates") +
    theme_void() +
    geom_point(data = plot_sf, shape = 21,
               aes(geometry = geometry, size = mgd),
               fill = color_dot, stroke = 0.2,
               color = 'white',
               stat = "sf_coordinates") +
    geom_point(data = plot_sf, shape = 21,
               aes(geometry = geometry, size = mgd),
               fill = color_dot, stroke = 0, alpha = 1,
               stat = "sf_coordinates") +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}