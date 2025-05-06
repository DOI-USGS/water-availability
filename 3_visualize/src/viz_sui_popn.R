#' @description Map with circles showing social vulnerability
#' 
#' @param in_sf target of spatial data frame
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png_out Location to save the png 
viz_popn_circles <- function(in_sf, 
                             color_scheme,
                             png_out,
                             width,
                             height){
  
  plot_sf <- in_sf |>
    mutate(color_hex = case_when(sui_category_5 == "Very low/\nnone" ~ color_scheme$sui_none,
                                 sui_category_5 == "Low" ~ color_scheme$sui_low,
                                 sui_category_5 == "Moderate" ~ color_scheme$sui_mod,
                                 sui_category_5 == "High" ~ color_scheme$sui_high,
                                 sui_category_5 == "Severe" ~ color_scheme$sui_severe))
  
  plot_sf <- plot_sf |>
    mutate(svi_category = case_when(mean_svi < 0.25 ~ 1,
                                    mean_svi < 0.5 ~ 2,
                                    mean_svi < 0.75 ~ 3,
                                    mean_svi < 1 ~ 14))
  
  points <- sf::st_centroid(plot_sf)
  
  plot <- ggplot(points) +    
    geom_sf(aes(size = svi_category), color = "white") +
    geom_sf(data = points |> filter(sui_category_5 == "Very low/\nnone"),
            aes(size = svi_category, color = color_hex), alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "Low"),
            aes(size = svi_category, color = color_hex), alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "Moderate"),
            aes(size = svi_category, color = color_hex), alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "High"),
            aes(size = svi_category), color = "white", alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "High"),
            aes(size = svi_category, color = color_hex), alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "Severe"),
            aes(size = svi_category), color = "white", alpha = 0.75) +
    geom_sf(data = points |> filter(sui_category_5 == "Severe"),
            aes(size = svi_category, color = color_hex), alpha = 0.75) +
    scale_size_identity() +
    scale_color_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  
  ggsave(plot = plot, filename = png_out, 
         width = width, height = height, dpi = 300, bg = "transparent")
  
  return(png_out)
}

#' @description Bar chart to show social vulnerability versus water limitation
#' 
#' @param in_sf target of spatial data frame
#' @param svi_break categorization used for social vulnerability
#' @param svi_label labels used for social vulnerability
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png_out Location to save the png 
viz_popn_barchart <- function(in_sf, svi_break, svi_label, width, height, color_scheme, png_out){
  
  raw_sf <- in_sf |>
    mutate(color_hex = case_when(sui_category_5 == "Very low/\nnone" ~ color_scheme$sui_none,
                                 sui_category_5 == "Low" ~ color_scheme$sui_low,
                                 sui_category_5 == "Moderate" ~ color_scheme$sui_mod,
                                 sui_category_5 == "High" ~ color_scheme$sui_high,
                                 sui_category_5 == "Severe" ~ color_scheme$sui_severe))
  
  plot_sf <- raw_sf |>
    filter(mean_svi >= (svi_break - 0.25),
           mean_svi < svi_break) |>
    mutate(svi_category = sprintf("%s social vulnerability", svi_label)) |>
    group_by(svi_category, sui_category_5, color_hex) |>
    summarize(n = n(),
              total_popn = sum(total_popn, na.rm = TRUE),
              svi_max = max(mean_svi),
              svi_min = min(mean_svi))
  
  ggplot(plot_sf, aes(y = svi_category, x = total_popn,
                      fill = color_hex)) +
    geom_bar(position = "fill", stat = "identity", 
             orientation = "y", width = 0.8, color = "black", 
             linewidth = 0.1) +
    scale_fill_identity() +
    theme_void() 
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300, bg = "transparent")
  
  return(png_out)
}