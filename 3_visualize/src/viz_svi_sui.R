viz_svi_sui <- function(in_df,
                        in_sf,
                        dry_onlyL,
                        color_scheme,
                        png_out,
                        width,
                        height){
  
  plot_df <- in_df |> 
    mutate(svi_factor = factor(svi_category,
                               levels = c("Low SVI", 
                                          "Moderate SVI", 
                                          "High SVI",
                                          "Severe SVI")),
           sui_factor = factor(sui_category,
                               levels = c("Low SUI",
                                          "Moderate SUI",
                                          "High SUI"),
                               labels = c("Wet", "Dry", "Severe")))
  
  plot_sf <- in_sf |>
    filter( ! is.na(sui_category), ! is.na(svi_category)) |>
    mutate(join_category = sprintf("%s-%s", sui_category, svi_category))
  
  
  legend_n_hucs <- ggplot(plot_df,
                          aes(y = n_hucs, x = sui_factor, fill = join_category)) +
    geom_bar(position = "stack", stat = "identity") +
    ylab("Number") +
    # same styles as belo
    scale_fill_manual(values = c(color_scheme$wet_blue_dark, 
                                 color_scheme$wet_blue_light,
                                 color_scheme$dry_red_dark,
                                 color_scheme$dry_red_light)) +
    theme_minimal() +
    theme(legend.position = "none",
          axis.title.x = element_blank())
  
  legend_prop_hucs <- ggplot(plot_df,
                             aes(y = n_hucs, x = sui_factor, fill = join_category)) +
    geom_bar(position = "fill", stat = "identity") +
    ylab("Proportion") +
    # same styles as above
    scale_fill_manual(values = c(color_scheme$wet_blue_dark, 
                                 color_scheme$wet_blue_light,
                                 color_scheme$dry_red_dark,
                                 color_scheme$dry_red_light)) +
    theme_minimal() +
    theme(legend.position = "none",
          axis.title.x = element_blank())
  
   map <- ggplot(plot_sf) +
    geom_sf(aes(fill = join_category),
            color = NA, size = 0)  +
    scale_fill_manual(values = c(
      ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$wet_blue_dark),
      ifelse(dry_onlyL, color_scheme$svg_col_default, color_scheme$wet_blue_light),
      color_scheme$dry_red_dark,
      color_scheme$dry_red_light)) +
    theme_void() +
    theme(legend.position = "none")
  
  blue_label <- color_scheme$wet_blue_dark
  red_label <- color_scheme$dry_red_dark
   
  final_plot <- ggdraw() +
    draw_plot(map, x = 0, y = 0.1, width = 1, height = 1) +
    draw_plot(legend_n_hucs, x = 0, y = 0.0, width = 0.25, height = 0.25) +
    draw_plot(legend_prop_hucs, x = 0.5, y = 0.0, width = 0.25, height = 0.25) +
    draw_text("Vulnerable populations in", x = 0, y = 0.33, 
              size = 12, hjust = 0) +
    draw_text("Dark Blue", x = 0.03, y = 0.28, size = 12, fontface = "bold",
              color = color_scheme$wet_blue_dark, hjust = 0) +
    draw_text("Dark Red", x = 0.18, y = 0.28, size = 12, fontface = "bold",
              color = color_scheme$dry_red_dark, hjust = 0) +
    draw_line(x = c(0.13, 0.15), y = c(0.26, 0.23), 
              color = color_scheme$wet_blue_dark) +
    draw_line(x = c(0.22, 0.200), y = c(0.26, 0.08), 
              color = color_scheme$dry_red_dark)
  
  ggsave(plot = final_plot,
         filename = png_out, device = "png", bg = "transparent",
         dpi = 300, units = "in", width = width, height = height)
}
