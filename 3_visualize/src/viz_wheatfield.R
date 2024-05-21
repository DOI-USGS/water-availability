plot_wheatfield <- function(data_in,
                            use_type, #options "te", "ps", "ir"
                            png_out,
                            width,
                            height){
  
  temp <- data_in |> 
    rename(
      total = sprintf("%s_total", use_type),
      gw_pct = sprintf("%s_gw_pct", use_type),
      sw_pct = sprintf("%s_sw_pct", use_type)) |>
    mutate(shifted_pct = sw_pct - 0.5) 
    
  # max_vector_length <- 300000
  # max_wu_mgd <- max(temp$total)
  # 
  # plot_data_centroids <- temp |>
  #   #sf::st_make_valid() |>
  #   sf::st_centroid() |>
  #   mutate(
  #     angle = shifted_pct * (45/0.5) * pi / 180,
  #     hyp = total*(max_vector_length/max_wu_mgd),
  #     x_dif = cos(angle)*hyp,
  #     y_dif = sin(angle)*hyp,
  #     x = sf::st_coordinates(.)[,1],
  #     y = sf::st_coordinates(.)[,2],
  #     x_end = x + x_dif,
  #     y_end = y + y_dif)
}
