#' @description Create maps of integrated water availability
#' 
#' @param in_df target of data frame
#' @param wa_type chr, code for which map to make. Uses codes in _targets.R
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png Location to save the png 
water_avail_map <- function(in_df, wa_type, color_scheme, png_out, width, height){
  
  plot_data <- in_df |> 
    select(Region_nam, matches(wa_type), geometry) |> 
    rename(stress = 2) |> 
    sf::st_as_sf()
  
  if(wa_type == "wa_sw_wq") {
    col_pal <- c("very low" = "#E8E8E9",
                 "low" = "#ADB3BD",
                 "moderate" = "#8B91A2",
                 "high" = "#61677A",
                 "severe" = "#323234")
  } else if(wa_type == "wa_sui") {
    col_pal <- c("very low" = "#E9E0C0",
                 "low" = "#DACC96",
                 "moderate" = "#BF8B67",
                 "high" = "#9D5353",
                 "severe" = "#632626")
  } else if(wa_type == "wa_gw_wq") {
    col_pal <- c("very low" = "#CEC5C5",
                 "low" = "#B2A4A4",
                 "moderate" = "#8A7575",
                 "high" = "#5E5050",
                 "severe" = "#3E3232")
  } else if(wa_type == "wa_ecoflow") {
    col_pal <- c("very low" = "#B8C7BF",
                 "low" = "#96ABA1",
                 "moderate" = "#6B8A7A",
                 "high" = "#51695E",
                 "severe" = "#223F32")
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