map_svi_sui <- function(in_sf,
                        color_scheme, png_out, width, height){
  
  plot_sf <- in_sf |>
    filter( ! is.na(sui_category_3), ! is.na(svi_category)) |>
    mutate(svi_factor = factor(svi_category,
                               levels = c("Severe SVI", "High SVI", "Moderate SVI", "Low SVI"),
                               labels = c("Severe", "High", "Moderate", "Low")))
  
  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = svi_factor),
            color = NA, size = 0)  +
    scico::scale_fill_scico_d(palette = "glasgow", begin  = 0.25, end = 0.6) +
    theme_void() 
  
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
}

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

viz_svi_sui_legend <- function(in_df, legend_type, color_scheme){
  
  plot_df <- in_df |> 
    mutate(sui_factor = factor(sui_category_3,
                               levels = c("Low SUI",
                                          "Medium SUI",
                                          "High SUI"),
                               labels = c("Low", "Med", "High")),
           join_factor = factor(join_category,
                                levels = c(
                                  "High SUI-High SVI",
                                  "High SUI-Moderate SVI",
                                  "High SUI-Low SVI",
                                  "Medium SUI-High SVI",
                                  "Medium SUI-Moderate SVI",
                                  "Medium SUI-Low SVI",
                                  "Low SUI-High SVI",
                                  "Low SUI-Moderate SVI",
                                  "Low SUI-Low SVI")))
  
  palette <- c(
    color_scheme$dry_red_vdark,
    color_scheme$dry_red_dark,
    color_scheme$dry_red_light,
    color_scheme$mid_vdark,
    color_scheme$mid_dark,
    color_scheme$mid_cream,
    color_scheme$wet_blue_dark,
    color_scheme$wet_blue_light,
    color_scheme$wet_blue_vlight)
  
  y_pos <- ifelse(legend_type == "Number", "stack", "fill")
  legend_label <- ifelse(legend_type == "Explainer", 
                         "Social Vulnerability", 
                         legend_type)
  
  
  legend <- ggplot(plot_df,
                   ggplot2::aes(y = if(legend_type != "Explainer"){n_hucs} else {rep(100, 9)}, 
                                x = sui_factor, fill = join_factor)) +
    geom_bar(position = y_pos, stat = "identity") +
    ylab(legend_label) +
    xlab("Water limitation") 
  
  if(legend_type == "Explainer"){
    legend_out <- legend + 
      scale_fill_manual(values = palette) +
      scale_y_continuous(breaks = c(0.15, 0.5, 0.85),
                         labels = c("Low", "Med", "High")) +
      theme_minimal() +
      theme(legend.position = "none",
            axis.title.y = element_text(size = 9, angle = 90),
            axis.title.x = element_text(size = 9),
            axis.text = element_text(size = 8))
  } else {
    legend_out <- legend +
      # same styles as below
      scale_fill_manual(values = palette) +
      theme_minimal() +
      theme(legend.position = "none",
            axis.title.y = element_text(size = 9, angle = 90),
            axis.title.x = element_text(size = 9),
            axis.text = element_text(size = 8))
  }
  
  return(legend_out)
}

#' @description Put the elements of svi together into 
#' 
#' @param in_sf target of spatial data frame
#' @param region name of the region, defined through tar_map()
#' @param wu_type chr, code for which map to make. Uses codes in _targets.R
#' @param color_scheme named colors defined in a target
#' @param width The size of the png width
#' @param height The size of the png height
#' @param png_out Location to save the png 
compose_svi_plot <- function(in_map,
                             legend_n,
                             legend_prop,
                             legend_explain,
                             png_out,
                             width, 
                             height){
  
  final_plot <- ggdraw() +
    draw_plot(in_map, x = 0, y = 0.1, width = 1, height = 1) +
    draw_plot(legend_n, x = 0.4, y = 0.0, width = 0.25, height = 0.25) +
    draw_plot(legend_prop, x = 0.7, y = 0.0, width = 0.25, height = 0.25) +
    draw_plot(legend_explain, x = 0, y = 0, width = 0.35, height = 0.35) 
  
  ggsave(plot = final_plot,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
  
  return(png_out)
}
