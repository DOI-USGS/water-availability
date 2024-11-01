source("3_visualize/src/svg_helpers.R")
source("3_visualize/src/viz_dumbbell.R")
source("3_visualize/src/viz_wheatfield.R")
source("3_visualize/src/viz_svi_sui.R")
source("3_visualize/src/viz_sui_popn.R")
source("3_visualize/src/viz_wq.R")
source("3_visualize/src/viz_ternary.R")

p3_targets <- list(
  ##############################################
  # 
  #           GLOBAL THEMES
  # 
  # Color theme
  tar_target(p3_colors_website,
             tibble(
               # elements for website components, not category specific
               svg_fill_default = "#d1cdc0",
               svg_col_default = "#edeadf", # background color of page
               shadow = "#926c68"
             )),
  tar_target(p3_colors_wu,
             p3_colors_website |> bind_cols(
               tibble(
                 # Water Use
                 te_gw_main = "#3E4F5C", #tern_5
                 te_sw_secondary = "#1687A5",
                 te_saline = "#01F9C6",
                 ir_gw_main = "#BBA167", #tern_9
                 ir_sw_secondary = "#D0CB02",
                 ps_gw_main = "#952D3D", #tern_1
                 ps_secondary = "#C72873",
                 tern_2 = "#705E70",
                 tern_3 = "#C63C51",
                 tern_4 = "#E0896D",
                 tern_6 = "#53697A",
                 tern_7 = "#637B73",
                 tern_8 = "#F9D689"))),
  tar_target(p3_colors_balance,
             p3_colors_website |> bind_cols(
               tibble(
                 # Water balance (wet/dry)
                 wet_blue_dark = "#39424f",
                 wet_blue_light = "#80909D",
                 wet_blue_vlight = "#9EABB3",
                 mid_vdark = "#796E58",
                 mid_dark = "#A0937D",
                 mid_cream = "#C3C3AC",
                 dry_red_vdark = "#492525",
                 dry_red_dark = "#965a5b",
                 dry_red_light = "#CFACAB"
               ))),
  
  tar_target(p3_fonts_website,
             tibble(
               legend_font = "Source Sans Pro",
               supporting_font = "Source Sans Pro",
               handwriting_font = "Caveat"
             )),
  tar_target(p3_load_legend_font,
             sysfonts::font_add_google(p3_fonts_website$legend_font)),
  tar_target(p3_load_support_font,
             sysfonts::font_add_google(p3_fonts_website$supporting_font)),
  tar_target(p3_load_hw_font,
             sysfonts::font_add_google(p3_fonts_website$handwriting_font)),
  
  ########################
  # SVG to overlay maps for website
  tar_target(p3_AggReg_svg,
             create_svg_for_web(in_sf = p2_AggReg_sf,
                                identifier = "AggReg_nam_nospace",
                                width = 6, height = 9,
                                file_out = "src/assets/svgs/AggReg.svg",
                                color_scheme = p3_colors_website),
             format = "file"),
  tar_target(p3_Reg_svg,
             create_svg_for_web(in_sf = p2_Reg_sf,
                                identifier = "Region_nam_nospace",
                                width = 6, height = 9,
                                file_out = "src/assets/svgs/Regions.svg",
                                color_scheme = p3_colors_website),
             format = "file"),
  
  ##############################################
  # 
  #           KEY TAKEAWAY 1: 
  #             
  #
  #
  tar_target(p3_map_stress_png,
             map_stress(in_sf = p2_HUC12_join_sui_svi_sf,
                         color_scheme = p3_colors_balance,
                        png_out = "public/images/01stress_map.png",
                        width = 6, height = 9)),
  
  ##############################################
  # 
  #           KEY TAKEAWAY 2: 
  #             More than 30 million people live in areas of 
  #             high/severe water imbalance
  #
  #
  # Use static branching
  tar_map(
    values = tibble(
      AggReg = c("CONUS", "Northeast_through_Midwest", "Southeast", "High_Plains", "Western")
    ),
    tar_target(p3_popn_circles_png,
               viz_popn_circles(in_df = p2_sui_popn_df,
                                region = AggReg,
                                color_scheme = p3_colors_balance,
                                fonts = p3_fonts_website,
                                png_out = sprintf("src/assets/images/k02_sui_popn_%s.png", AggReg),
                                width = 6,
                                height = 6),
               format = "file")
  ),
  
  
  ##############################################
  # 
  #           KEY TAKEAWAY 3: 
  #             A high proportion of the population living 
  #             in areas with water availability limitations 
  #             are considered to be socially vulnerable.
  #
  #
  tar_target(p3_map_sui_svi_grob,
             map_svi_sui(in_sf = p2_HUC12_join_sui_svi_sf,
                         dry_onlyL = FALSE,
                         color_scheme = p3_colors_balance)),
  tar_target(p3_map_dry_sui_svi_grob,
             map_svi_sui(in_sf = p2_HUC12_join_sui_svi_sf,
                         dry_onlyL = TRUE,
                         color_scheme = p3_colors_balance)),
  tar_target(p3_legend_n_grob,
             viz_svi_sui_legend(in_df = p2_sui_svi_HUC12_df,
                                legend_type = "Number",
                                color_scheme = p3_colors_balance)),
  tar_target(p3_legend_prop_grob,
             viz_svi_sui_legend(in_df = p2_sui_svi_HUC12_df,
                                legend_type = "Proportion",
                                color_scheme = p3_colors_balance)),
  tar_target(p3_legend_explainer_grob,
             viz_svi_sui_legend(in_df = p2_sui_svi_HUC12_df,
                                legend_type = "Explainer",
                                color_scheme = p3_colors_balance)),
  tar_target(p3_map_sui_svi_png,
             compose_svi_plot(in_map = p3_map_sui_svi_grob,
                              legend_n = p3_legend_n_grob,
                              legend_prop = p3_legend_prop_grob,
                              legend_explain = p3_legend_explainer_grob,
                              png_out = "src/assets/images/k03_sui_svi_map.png",
                              width = 6, 
                              height = 5),
             format = "file"),
  tar_target(p3_map_dry_sui_svi_png,
             compose_svi_plot(in_map = p3_map_dry_sui_svi_grob,
                              legend_n = p3_legend_n_grob,
                              legend_prop = p3_legend_prop_grob,
                              legend_explain = p3_legend_explainer_grob,
                              png_out = "src/assets/images/k03_sui_svi_dry_map.png",
                              width = 6,
                              height = 5),
             format = "file"),
  
  
  ##############################################
  # 
  #           KEY TAKEAWAY 4: 
  #             Periods of low precipitation can have cascading 
  #             effects throughout the water cycle, expanding areas of 
  #             water stress and exacerbating water quality issues 
  #
  #
  
  ##############################################
  # 
  #           KEY TAKEAWAY 5: 
  #             Water quality is affected by natural and human sources, 
  #             including springs and streams, land use activities, and 
  #             air pollution.
  #
  #
  tar_map(
    values = tibble(
      AggReg = c("CONUS", "Northeast_through_Midwest", "Southeast", "High_Plains", "Western")
    )
   # tar_target(p3_wq_tn_barchart_png,
  #             viz_wq_bars(in_df = p1_wq_Reg_df_tn,
  #                         region = AggReg,
  #                         color_scheme = p3_colors_balance,
  #                         fonts = p3_fonts_website,
  #                         png_out = sprintf("src/assets/images/k05_wq_tn_bar_%s.png", AggReg),
  #                         width = 6,
  #                         height = 6),
  #             format = "file")
  ),
  
  ##############################################
  # 
  #           KEY TAKEAWAY 6: 
  #             Threats to water quality depend on what the water is used 
  #             for (e.g., drinking water versus recreation) and where the 
  #             water is coming from (e.g., surface water, groundwater).
  #
  #
  
  ##############################################
  # 
  #           KEY TAKEAWAY 7: 
  #             About 225,000 million gallons of freshwater get used per 
  #             day for crop irrigation, public supply, and thermoelectric 
  #             power generation in the lower 48 states, and not all of 
  #             this water gets returned directly to the local environment.
  #
  #
  
  ##############################################
  # 
  #           KEY TAKEAWAY 8: 
  #             How we use water varies across the country, 
  #             including the source of water (groundwater 
  #             versus surface water) and the type of use 
  #             (e.g., crop irrigation, public supply, or 
  #             thermoelectric power generation).
  # 
  # tar_target(p3_k8_ps_CONUS_wheatfield_png,
  #            plot_wheatfield(data_in = p2_HUC8_join_wu_AggRegGrp_sf,
  #                            regions_sf = p2_Reg_sf,
  #                            use_type = "ps",
  #                            color_scheme = p3_colors_wu,
  #                            png_out = "src/assets/images/k08_ps_wheatfield_CONUS.png",
  #                            width = 6,
  #                            height = 5),
  #            format = "file"),
  # tar_target(p3_k8_ir_CONUS_wheatfield_png,
  #            plot_wheatfield(data_in = p2_HUC8_join_wu_AggRegGrp_sf,
  #                            regions_sf = p2_Reg_sf,
  #                            use_type = "ir",
  #                            color_scheme = p3_colors_wu,
  #                            png_out = "src/assets/images/k08_ir_wheatfield_CONUS.png",
  #                            width = 6,
  #                            height = 5),
  #            format = "file"),
  # tar_target(p3_k8_te_CONUS_wheatfield_png,
  #            plot_wheatfield(data_in = p2_HUC8_join_wu_AggRegGrp_sf,
  #                            regions_sf = p2_Reg_sf,
  #                            use_type = "te",
  #                            color_scheme = p3_colors_website,
  #                            png_out = "src/assets/images/k08_te_wheatfield_CONUS.png",
  #                            width = 6,
  #                            height = 6),
  #            format = "file"),
  # tar_target(p3_k8_legend_png,
  #            wheatfield_legend(
  #              fonts = p3_fonts_website,
  #              png_out = "src/assets/images/k08_legend.png"),
  #            format = "file"),
  
  tar_target(p3_ternary_map_CONUS_png,
             ternary_map(in_sf = p2_HUC8_join_wu_sf,
                         width = 8,
                         height = 6,
                         png_out = "public/images/kf08_wu_ternary.png"),
             format = "file"),
  tar_target(p3_ternary_plot_png,
             ternary_plot(in_df = p2_wu_ternary_df,
                          width = 8,
                          height = 8,
                          png_out = "public/images/kf08_wu_legend.png"),
             format = "file")
  
  
  ##############################################
  # 
  #           KEY TAKEAWAY 9: 
  #             Not all the water withdrawn for human water use 
  #             returns to the local environment.
  # 
  
  ##############################################
  # 
  #           KEY TAKEAWAY 10: 
  #             The top future threats to water availability in the 
  #             US vary regionally and include increases in drought, 
  #             flooding, and heavy precipitation along with declines in 
  #             snow and ice.
)
