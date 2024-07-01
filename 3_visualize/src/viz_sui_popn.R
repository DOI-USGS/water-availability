viz_popn_circles <- function(in_df,
                             region,
                             color_scheme,
                             fonts,
                             png_out,
                             width,
                             height){
  
  # process data for circle packing
  packing <- packcircles::circleProgressiveLayout(in_df$popn_huc, 
                                                  sizetype = "area")
  circle_pack_data <- cbind(in_df, packing)
  dat.gg <- circleLayoutVertices(packing, npoints = 50)
  dat.gg$value <- rep(in_df$sui_category, each = 51)
  dat.gg$AggReg <- rep(in_df$AggReg_nam_nospace, each = 51)
  

  # prep data for proportion bar (summed to each SUI class)
  total_bar_height = sum(in_df$popn_huc, na.rm = TRUE)
  
  reg_part_to_whole_summed <- in_df |>
    filter(if(region == "CONUS") TRUE else AggReg_nam_nospace == region) |>
    group_by(sui_factor) |>
    summarize(sum_pop = sum(popn_huc, na.rm = TRUE)) |>
    ungroup() |>
    mutate(year = "2020") 
  
  reg_part_to_whole_prop <- reg_part_to_whole_summed |>
    arrange(rev(sui_factor), .by_group = TRUE) |>
    mutate(pos = cumsum(sum_pop) - sum_pop/2,
           ymax = cumsum(sum_pop)) |>
    arrange(sui_factor) |>
    mutate(label_pop = pretty_num(sum_pop))
  
  
  ## select data for plot type
  if(region == "CONUS"){
    plot_data <- dat.gg
  } else {
    plot_data <- dat.gg |> filter(AggReg == region)
  }
  
  
  # set up color scheme
  col_pal <- c("Severe" = color_scheme$dry_red_dark, 
               "High" = color_scheme$dry_red_light, 
               "Moderate" = color_scheme$svg_col_default, 
               "Low" = color_scheme$wet_blue_light, 
               "Very low/\nnone" = color_scheme$wet_blue_dark)
  
  # circle packing plot
  (circle_plot <- ggplot() + 
      geom_polygon(data = dat.gg, 
                   aes(x, y, group = id, fill = as.factor(value)), 
                   linewidth = 0.1,
                   colour = "black", alpha = 0.3) + 
      geom_polygon(data = plot_data, 
                   aes(x, y, group = id, fill = as.factor(value)), 
                   linewidth = 0.1,
                   colour = "black") + 
      scale_fill_manual(values = col_pal, 
                        breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"), 
                        name = "Water Stress Level") +
      geom_text(data = subset(circle_pack_data, 
                              sui_factor %in% c("High", "Moderate", "Low")), 
                aes(x, y, label = label_pop), size = 3, color = "black")+
      geom_text(data = subset(circle_pack_data, 
                              sui_factor %in% c("Severe", "Very low/\nnone")), 
                aes(x, y, label = label_pop), size = 3, color = "white")+
      theme_void() + 
      theme(legend.position="none", 
            plot.margin = unit(c(1,1,1,1),"cm")) + 
      coord_equal()
  )
  
  
  # stacked bar
  (bar_plot <- ggplot() +
      geom_bar(data = reg_part_to_whole_prop, 
               stat = "identity",
               aes(x = year, 
                   y = sum_pop, 
                   fill = sui_factor),
               width = 0.4) +
      geom_text(data = reg_part_to_whole_prop,
                aes(x = year, y = pos, label = label_pop),
                color = "black", size = 3)+
      geom_text(data = reg_part_to_whole_prop,
                aes(x = year, y = pos, label = sui_factor),
                color = "black", size = 3,
                hjust = -0, nudge_x = 0.28)+
      scale_fill_manual(values = col_pal, 
                        breaks = c("Severe", "High", "Moderate", "Low", "Very low/\nnone"))+
      ylim(c(0, total_bar_height + 10000)) +
      theme_void()+
      theme(legend.position = "none",
            text = element_text(family = fonts$supporting_font))
  )
  
  ggdraw(ylim = c(0, 1), # 0-1 scale makes it easy to place viz items on canvas
         xlim = c(0, 1)) +
    # the main plot
    draw_plot(circle_plot,
              x = 0.14, y = 0.04,
              height = 0.95, width = 0.95) +
    draw_plot(bar_plot,
              x = -0.1, y = 0.1,
              height = 0.91, width = 0.35) +
    # explainer text
    draw_label("1 circle = 1 watershed (huc12)\nSize = population",
               fontfamily = fonts$handwriting_font,
               x = 0.93, y = 0.88,
               hjust = 1, vjust = 0,
               color = "black", size = 15) 
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300)
  
  return(png_out)
}
