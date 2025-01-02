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

viz_popn_barchart <- function(in_sf, width, height, color_scheme, png_out){
  
  plot_sf <- in_sf |>
    mutate(color_hex = case_when(sui_category_5 == "Very low/\nnone" ~ color_scheme$sui_none,
                                 sui_category_5 == "Low" ~ color_scheme$sui_low,
                                 sui_category_5 == "Moderate" ~ color_scheme$sui_mod,
                                 sui_category_5 == "High" ~ color_scheme$sui_high,
                                 sui_category_5 == "Severe" ~ color_scheme$sui_severe))
  
  plot_sf <- plot_sf |>
    mutate(svi_category = case_when(mean_svi < 0.25 ~ "Low social vulnerability",
                                    mean_svi < 0.5 ~ "Moderate social vulnerability",
                                    mean_svi < 0.75 ~ "High social vulnerability",
                                    mean_svi < 1 ~ "Severe social vulnerability"),
           svi_factor = factor(svi_category, 
                               levels = c("Low social vulnerability",
                                          "Moderate social vulnerability",
                                          "High social vulnerability",
                                          "Severe social vulnerability"))) |>
    group_by(svi_factor, sui_category_5, color_hex) |>
    summarize(n = n(),
              total_popn = sum(total_popn, na.rm = TRUE))
  
  ggplot(plot_sf, aes(y = svi_factor, x = total_popn,
                      fill = color_hex)) +
    geom_bar(position = "fill", stat = "identity", orientation = "y", width = 0.8) +
    scale_fill_identity() +
    theme_void() +
    theme(axis.text.y = element_text(hjust = 0))
  
  ggsave(filename = png_out, 
         width = width, height = height, dpi = 300, bg = "transparent")
  
  return(png_out)
}