
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
   
  if(wa_type == "wa_sw_wq"){
    title <- "surface water quality"
  }else if(wa_type == "wa_sui"){
    title <- "surface water balance"
  }else if (wa_type == "wa_gw_wq"){
    title <- "groundwater quality"
  }else if(wa_type == "wa_ecoflow"){
    title <- "ecological flow alteration"
  }
  
  ggplot(plot_data) +
    geom_sf(aes(fill = stress), color = color_scheme$svg_col_default) +
    scale_fill_manual(values = c(col_pal),
                      breaks = c("very low", "low", "moderate", "high", "severe"))+
    #ggtitle(title)+
    theme_void()+
    theme(legend.position = "none"
      #legend.direction = "horizontal",
          #legend.text = element_blank(),
          #legend.title = element_blank()
      )
  
  ggsave(filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}