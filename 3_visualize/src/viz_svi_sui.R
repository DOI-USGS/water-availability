map_svi_sui <- function(in_sf,
                        dry_onlyL,
                        color_scheme){
  
  plot_sf <- in_sf |>
    filter( ! is.na(sui_category_3), ! is.na(svi_category)) |>
    mutate(join_category = sprintf("%s-%s", sui_category_3, svi_category),
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
  
  conditional_palette <- c(
    color_scheme$dry_red_vdark,
    color_scheme$dry_red_dark,
    color_scheme$dry_red_light,
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$mid_vdark),
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$mid_dark),
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$mid_cream),
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$wet_blue_dark),
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$wet_blue_light),
    ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$wet_blue_vlight))
  
  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = join_factor),
            color = NA, size = 0)  +
    scale_fill_manual(values = conditional_palette) +
    theme_void() +
    theme(legend.position = "none")
  
  return(map)
  
}

map_stress <- function(in_sf,
                      color_scheme,
                       png_out,
                      width,
                      height){
  
  plot_sf <- in_sf |>
    filter( ! is.na(sui_category_5)) |>
    mutate(color_hex = case_when(sui_category_5 == "Very low/\nnone" ~ color_scheme$wet_blue_dark,
                                 sui_category_5 == "Low" ~ color_scheme$wet_blue_light,
                                 sui_category_5 == "Moderate" ~ color_scheme$svg_col_default,
                                 sui_category_5 == "High" ~ color_scheme$dry_red_light,
                                 sui_category_5 == "Severe" ~ color_scheme$dry_red_dark))
  
  map <- ggplot(plot_sf) +
    geom_sf(aes(fill = color_hex),
            color = NA, size = 0)  +
    scale_fill_identity() +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(plot = map,
         filename = png_out, device = "png", bg = "transparent",
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
                          aes(y = if(legend_type != "Explainer"){n_hucs} else {rep(100, 9)}, 
                              x = sui_factor, fill = join_factor)) +
    geom_bar(position = y_pos, stat = "identity") +
    ylab(legend_label) +
    xlab("Water stress") 
  
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
