#' @description Map water supply and use index (water limitation)
#' 
#' @param in_sf target of spatial data frame
#' @param in_regions spatial data frame of regions for mapping
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png_out Location to save the png 
map_sui <- function(in_sf,
                       in_regions,
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
  
  map <- ggplot(plot_sf) +
    geom_sf(data = in_regions, 
            fill = NA,
            color = NA, linewidth = 0.1) +
    geom_sf(aes(fill = color_hex),
            color = NA, size = 0)  +
    scale_fill_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}

#' @description Bar chart of monthly water supply and use index (water limitation)
#' 
#' @param in_df target of data frame with monthly water limitation
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png_out Location to save the png 
plot_monthly_sui <- function(in_df, 
                             color_scheme,
                             png_out,
                             width,
                             height) {
  
  plot_df <- in_df |>
    mutate(
      year = substr(year_month, 1, 4),
      month = substr(year_month, 6, 7),
      date = as_date(paste(year, month, '01', sep = '-')))
  
  ggplot(data = plot_df, aes(x = date,
                           y = n_hucs, 
                           fill = sui_category)) +
           geom_bar(position = "fill",
                    stat = "identity", width = 32) +
    scale_fill_manual(values = c(color_scheme$sui_none,
                                 color_scheme$sui_low,
                                 color_scheme$sui_mod,
                                 color_scheme$sui_high,
                                 color_scheme$sui_severe)) +
    scale_x_date(breaks = "1 year", date_labels = "%Y",
                 limits = c(as.Date("2010-01-01"), as.Date("2020-01-01"))) +
    scale_y_continuous(labels = scales::percent) +
    theme_void(base_size = 11) +
    theme(legend.position = "none",
          panel.grid.major = element_line(color = color_scheme$shadow, linewidth = 0.1),
          axis.text.x = element_text(color = color_scheme$shadow, size = 14,
                                   margin=margin(0,0,0,0)),
          axis.text.y = element_text(color = color_scheme$shadow, size = 14,
                                     margin=margin(0,0,0,30)))
  
  
  ggsave(filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}

