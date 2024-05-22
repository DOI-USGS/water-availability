plot_wheatfield <- function(data_in,
                            regions_sf,
                            use_type, #options "te", "ps", "ir"
                            color_scheme,
                            png_out,
                            width,
                            height){
  
  temp <- data_in |> 
    rename(
      total = sprintf("%s_total", use_type),
      gw_pct = sprintf("%s_gw_pct", use_type),
      sw_pct = sprintf("%s_sw_pct", use_type)) |>
    mutate(shifted_pct = sw_pct - 0.5) 
  
  max_vector_length <- 300000
  max_wu_mgd <- max(temp$total, na.rm = TRUE)
  
  
  
  
  plot_data_centroids <- temp |>
    sf::st_make_valid() |>
    sf::st_centroid() 
  
  x_temp <- sf::st_coordinates(plot_data_centroids)[,1]
  y_temp <- sf::st_coordinates(plot_data_centroids)[,2]
  
  plot_data <- plot_data_centroids |>
    mutate(
      angle = shifted_pct * (45/0.5) * pi / 180,
      hyp = total*(max_vector_length/max_wu_mgd),
      x = x_temp,
      y = y_temp,
      x_dif = cos(angle)*hyp,
      y_dif = sin(angle)*hyp,
      x_end = x + x_dif,
      y_end = y + y_dif)
  
  ggplot(regions_sf) + 
    ggfx::with_shadow(
      geom_sf(data = regions_sf, 
              color = color_scheme$svg_col_default, 
              fill = color_scheme$svg_fill_default, 
              size = 0.1),
      colour = color_scheme$ps_gw_main,
      x_offset = 0,
      y_offset = 0,
      sigma = 12) +
    geom_segment(data = plot_data, 
                 aes(col = shifted_pct, 
                     x = x, y = y, 
                     xend = x_end, yend = y_end), 
                 linewidth = 0.5) +
    scico::scale_color_scico(palette = 'broc', direction = -1, begin = 0.2, end = 0.8) +
    scale_x_continuous(expand = c(0.06,0.06)) +
    scale_y_continuous(expand = c(0.06,0.06)) +
    theme_void() +
    theme(legend.position = 'None')
  
  ggsave(filename = png_out,
         width = width, height = height, dpi = 300)
  
  return(png_out)
}
