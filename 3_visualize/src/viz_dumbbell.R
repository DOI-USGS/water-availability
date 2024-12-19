# Dumbbell chart to show total water use for gw versus sw
dumbbell_gw_v_sw <- function(in_sf,
                             agg_reg,
                             wu_type,
                             color_scheme,
                             width,
                             height,
                             png_out){
  
  if(wu_type == "all"){
    proc_in_sf <- in_sf |>
      dplyr::mutate(x_long = sf::st_coordinates(sf::st_centroid(in_sf))[,1]) |> 
      dplyr::mutate(sw_total_wu = rowSums(dplyr::across(c(ps_sw, ir_sw, te_sw))),
                    gw_total_wu = rowSums(dplyr::across(c(ps_gw, ir_gw, te_gw))))
  } else if(wu_type != "all"){
    proc_in_sf <- in_sf |>
      dplyr::mutate(x_long = sf::st_coordinates(sf::st_centroid(in_sf))[,1]) |> 
      dplyr::rename(sw_total_wu = sprintf("%s_sw", wu_type),
                    gw_total_wu = sprintf("%s_gw", wu_type))  
  }
  max(proc_in_sf$gw_total_wu)
  
  if(agg_reg == "CONUS"){
  max_sw <- proc_in_sf |>
    select(x_long, sw_total_wu) |>
    drop_na() |> 
    filter(sw_total_wu == max(sw_total_wu)) |> 
    unique()
  max_gw <- proc_in_sf |>
    select(x_long, gw_total_wu) |>
    drop_na() |> 
    filter(gw_total_wu == max(gw_total_wu)) |> 
    unique()
  } 
  else if(agg_reg != "CONUS"){
    max_sw <- proc_in_sf |>
      filter(AggRegion_nam == agg_reg) |> 
      select(x_long, sw_total_wu) |>
      drop_na() |> 
      filter(sw_total_wu == max(sw_total_wu)) |> 
      unique()
    max_gw <- proc_in_sf |>
      filter(AggRegion_nam == agg_reg) |> 
      select(x_long, gw_total_wu) |>
      drop_na() |> 
      filter(gw_total_wu == max(gw_total_wu)) |> 
      unique()
  }
  
  plot <- ggplot(proc_in_sf)  +
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
             vjust = 0, color = color_scheme$dumbbell_sw) + 
    annotate("text", x = max_gw$x_long,
             y = -1*max_gw$gw_total_wu, 
             label = sprintf("%s mgd", round(max_gw$gw_total_wu)),
             vjust = 1, color = color_scheme$dumbbell_gw) + 
    annotate("text", x = -Inf, y = 0, label = "W", vjust = -0.5, hjust = 0, color = "black")+
    annotate("text", x = Inf, y = 0, label = "E", vjust = -0.5, hjust = 1, color = "black")+
    geom_hline(yintercept = 0, linewidth = 0.4) +
    theme_void() 
  
  if(agg_reg == "CONUS"){
    plot <- plot +
      geom_linerange(data = proc_in_sf, 
                     aes(x = x_long,
                         ymax = sw_total_wu,
                         ymin = 0),
                     color = color_scheme$dumbbell_sw, alpha = 0.6,
                     linewidth = 1.5) +
      geom_linerange(data = proc_in_sf,
                     aes(x = x_long,
                         ymin = gw_total_wu*-1,
                         ymax = 0),
                     color = color_scheme$dumbbell_gw, alpha = 0.6,
                     linewidth = 1.5) 
  } else if(agg_reg != "CONUS"){
    plot <- plot+
      geom_linerange(data = subset(proc_in_sf, AggRegion_nam == agg_reg), 
                     aes(x = x_long,
                         ymax = sw_total_wu,
                         ymin = 0),
                     color = color_scheme$dumbbell_sw, alpha = 0.6,
                     linewidth = 1.5) +
      geom_linerange(data = subset(proc_in_sf, AggRegion_nam == agg_reg),
                     aes(x = x_long,
                         ymin = gw_total_wu*-1,
                         ymax = 0),
                     color = color_scheme$dumbbell_gw, alpha = 0.6,
                     linewidth = 1.5) 
  }
  
  ggsave(filename = png_out, plot = plot, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}