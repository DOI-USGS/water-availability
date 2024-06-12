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
              color = color_scheme$svg_fill_default, 
              fill = color_scheme$svg_col_default, 
              size = 0.1),
      colour = color_scheme$shadow,
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


############  CREATE LEGEND 

wheatfield_legend <- function(png_out, fonts){
  breaks <- c(25, 33, 66, 75)
  pos <- 0.5
  determinent <- "Water\nsource"
  
  require(ggplot2)
  
  get.poly <- function(a, b, r1 = 0.5, r2 = 0.75) {
      th.start <- pi * (1 - a / 100)
      th.end   <- pi * (1 - b / 100)
      th       <- seq(th.start, th.end, length = 1000)
      x        <- r1 * cos(th)
      xend     <- r2 * cos(th)
      y        <- r1 * sin(th)
      yend     <- r2 * sin(th)
      data.frame(x, y, xend, yend)
  }
  
    
  vertical_nudge <- 0.4
    
  ggplot() + 
      geom_segment(data = get.poly(breaks[1],breaks[4]),
                   aes(x = x, y = vertical_nudge + y, xend = xend, 
                       yend = vertical_nudge + yend, color = xend)) +
      scico::scale_color_scico(palette = 'broc', begin = 0.2, end = 0.8) +
      geom_segment(data = get.poly(pos - 1, pos + 1, vertical_nudge),
                   aes(x = x, y  = vertical_nudge + y, xend = x, 
                       yend = vertical_nudge + yend)) +
      geom_text(data = as.data.frame(breaks), size = 6, 
                family = fonts$supporting_font, 
                vjust = 0.5, hjust = 1,
                aes(x = 0.7 * cos(pi * (1 - breaks / 100)),  y = 0.8), 
                label = c('100%\nsurface water', '', '', "100%\ngroundwater"), 
                angle = 90, lineheight = 0.8) +
      annotate("text", x  = 0, y = 0.35,label = determinent, vjust = 0.35,
               size = 10, family = fonts$legend_font, fontface = "bold", angle = 90, 
               hjust = 0, lineheight = 0.8)+
      coord_fixed()+
      theme_bw()+
      theme(axis.text=element_blank(),
            axis.title=element_blank(),
            axis.ticks=element_blank(),
            panel.grid=element_blank(),
            panel.border=element_blank(),
            legend.position = "none",
            panel.background = element_blank(),
            plot.background = element_blank())

  ggsave(png_out)
  
  return(png_out)
}