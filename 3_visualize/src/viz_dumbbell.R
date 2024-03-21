# Dumbbell chart to show total water use for gw versus sw
dumbbell_gw_v_sw <- function(in_sf,
                             in_CONUS,
                             stacked_from_zeroL, 
                             #focal_region,
                             color_scheme,
                             #plot_title,
                             width,
                             height,
                             png_out){
  
  in_sf <- in_sf |>
    mutate(x_long = st_coordinates(st_centroid(in_sf))[,1])
  
  in_CONUS <- in_CONUS |>
    mutate(x_long = st_coordinates(st_centroid(in_CONUS))[,1])
  
  max_sw <- in_sf |>
    filter(sw_total_wu == max(sw_total_wu))
  max_gw <- in_sf |>
    filter(gw_total_wu == max(gw_total_wu))
  
  ggplot(in_CONUS)  + 
    geom_linerange(aes(x = x_long,
                       ymax = sw_total_wu,
                       ymin = 0),
                   color = "#999999", alpha = 0.2) +
    geom_linerange(aes(x = x_long,
                       ymin = gw_total_wu*-1,
                       ymax = 0),
                   color = "#999999", alpha = 0.2) +
    geom_linerange(data = in_sf,
                   aes(x = x_long,
                       ymax = sw_total_wu,
                       ymin = 0),
                   color = "#065867", alpha = 0.6,
                   linewidth = 1.5) +
    geom_linerange(data = in_sf,
                   aes(x = x_long,
                       ymin = gw_total_wu*-1,
                       ymax = 0),
                   color = "#F09300", alpha = 0.6,
                   linewidth = 1.5) +
    annotate("text", x = max_sw$x_long,
             y = max_sw$sw_total_wu, 
             label = sprintf("%s mgd", round(max_sw$sw_total_wu)),
             vjust = 0, color = "#065867") +
    annotate("text", x = max_gw$x_long,
             y = -1*max_gw$gw_total_wu, 
             label = sprintf("%s mgd", round(max_gw$gw_total_wu)),
             vjust = 1, color = "#F09300") +
    geom_hline(yintercept = 0, linewidth = 0.4) +
    theme_void() 
  
  ggsave(png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}