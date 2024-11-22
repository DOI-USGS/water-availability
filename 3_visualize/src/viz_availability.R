
water_avail_map <- function(in_df, wa_type, color_scheme, png_out, width, height){
  
  plot_data <- in_df |> 
    select(Region_nam, matches(wa_type), geometry) |> 
    rename(stress = 2) |> 
    sf::st_as_sf()

  col_pal <- c("very low" = "#f9d689",
               "low" = "#e0a75e",
               "moderate" = "#b17457",
               "high" = "#603f26",
               "severe" = "#181c14")
  
  ggplot(plot_data) +
    geom_sf(aes(fill = stress), color = color_scheme$svg_col_default, linewidth = 0.5) +
    scale_fill_manual(values = c(col_pal),
                      breaks = c("very low", "low", "moderate", "high", "severe"))+
    theme_void()+
    theme(legend.position = "none"
      )
  
  ggsave(filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}