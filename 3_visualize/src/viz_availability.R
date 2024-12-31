
water_avail_map <- function(in_df, wa_type, color_scheme, png_out, width, height){
  
  plot_data <- in_df |> 
    select(Region_nam, matches(wa_type), geometry) |> 
    rename(stress = 2) |> 
    sf::st_as_sf()
  
  if(wa_type == "wa_sw_wq") {
    col_pal <- c("very low" = "#F0EAF9",
                 "low" = "#E8CAE1",
                 "moderate" = "#DCA1C2",
                 "high" = "#AB5F90",
                 "severe" = "#6B3858")
  } else if(wa_type == "wa_sui") {
    col_pal <- c("very low" = "#E6C398",
                 "low" = "#E5AA7F",
                 "moderate" = "#EA906D",
                 "high" = "#E07560",
                 "severe" = "#733303")
  } else if(wa_type == "wa_gw_wq") {
    col_pal <- c("very low" = "#AB99B8",
                 "low" = "#7D628E",
                 "moderate" = "#585380",
                 "high" = "#403261",
                 "severe" = "#260C3F")
  } else if(wa_type == "wa_ecoflow") {
    col_pal <- c("very low" = "#C6EFB1",
                 "low" = "#94CB78",
                 "moderate" = "#7FA35C",
                 "high" = "#788554",
                 "severe" = "#545E3B")
  }
  
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