# Dumbbell chart to show total water use for gw versus sw
dumbbell_gw_v_sw <- function(in_sf,
                             agg_reg,
                             wu_type,
                             #in_CONUS,
                             #stacked_from_zeroL, 
                             #focal_region,
                             color_scheme,
                             #plot_title,
                             width,
                             height,
                             png_out){
  
  in_sf <- in_sf |>
    dplyr::mutate(x_long = sf::st_coordinates(sf::st_centroid(in_sf))[,1]) |> 
    dplyr::rename(sw_total_wu = sprintf("%s_sw.x", wu_type),
                  gw_total_wu = sprintf("%s_gw.x", wu_type))  
  
#  if(agg_reg != "CONUS"){
#    filtered_in_sf <- in_sf |> 
#      dplyr::filter(AggRegion_nam == agg_reg)
#  } else if(agg_reg == "CONUS"){
#    filtered_in_sf <- in_sf
#  }
  
  #in_CONUS <- in_CONUS |>
    #mutate(x_long = st_coordinates(st_centroid(in_CONUS))[,1])
  
  max_sw <- in_sf |>
    filter(sw_total_wu == max(sw_total_wu)) 
  max_gw <- in_sf |>
    filter(gw_total_wu == max(gw_total_wu))
  
  
  plot <- ggplot(in_sf)  + #in_CONUS
    geom_linerange(aes(x = x_long,
                       ymax = sw_total_wu,
                       ymin = 0),
                   color = "#999999", alpha = 0.2) +
    geom_linerange(aes(x = x_long,
                       ymin = gw_total_wu*-1,
                       ymax = 0),
                   color = "#999999", alpha = 0.2) +
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
  
  if(agg_reg == "CONUS"){
    plot <- plot +
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
                     linewidth = 1.5) 
  } else if(agg_reg != "CONUS"){
    plot <- plot+
      geom_linerange(data = subset(in_sf, AggRegion_nam == agg_reg), 
                     aes(x = x_long,
                         ymax = sw_total_wu,
                         ymin = 0),
                     color = "#065867", alpha = 0.6,
                     linewidth = 1.5) +
      geom_linerange(data = subset(in_sf, AggRegion_nam == agg_reg),
                     aes(x = x_long,
                         ymin = gw_total_wu*-1,
                         ymax = 0),
                     color = "#F09300", alpha = 0.6,
                     linewidth = 1.5) 
  }
  
  ggsave(filename = png_out, plot = plot, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}