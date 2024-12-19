plot_deviations <- function(data_in, region, width, height, png_out, color_scheme){
  
  # set up factors for plotting
  plot_df <- data_in |>
    mutate(name = factor(supply_category, 
                         levels = c("precip", "et", "sm", "sf"),
                         labels = c("Precipitation", 
                                    "Evapotranspiration", 
                                    "Soil moisture",
                                    "Streamflow"))) |>
    mutate(date = as_date(paste(water_year, month, '01', sep = '-'))) |>
    # filter to Northern High Plains
    filter(Region_nam == region) |>
    # fewer years in view
    filter(water_year >= 2010, water_year <= 2015)
  
  main_plot <- ggplot(data = plot_df,
                      aes(x = date, y = norm_val, color = hi_lo)) +
    geom_linerange(aes(ymin = 0, ymax = norm_val), linewidth = 1.3) +
    facet_wrap(~ name, nrow = 4) +
    scale_color_manual(values = c(color_scheme$ws_demand,
                                  color_scheme$ws_supply)) +
    scale_x_date(breaks = "1 year", date_labels = "%Y") +
    theme_void() +
    theme(legend.position = "none",
          panel.grid.major.x = element_line(color = color_scheme$shadow, linewidth = 0.1),
          axis.text.x = element_text(color = color_scheme$shadow, size = 8),
          plot.margin = margin(t = 0,  # Top margin
                               r = 5,  # Right margin
                               b = 0,  # Bottom margin
                               l = 5)) # Left margin)
  
  
  # background
  canvas <- grid::rectGrob(
    x = 0, y = 0,
    width = width, height = height,
    gp = grid::gpar(fill = "transparent", alpha = 1, 
                    col = "transparent")
  )
  
  plot_composition <- 
    ggdraw(ylim = c(0,height),
           xlim = c(0,width)) +
    # a background
    draw_grob(canvas,
              x = 0, y = 1,
              height = height, width = width,
              hjust = 0, vjust = 1) +
    # just nutrient map
    draw_plot(main_plot,
              x = 0.00,
              y = 0.00,
              height = height,
              width = width) 
  
  ggsave(plot_composition,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
  
}