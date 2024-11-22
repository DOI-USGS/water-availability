source("3_visualize/src/svg_helpers.R")
source("3_visualize/src/viz_dumbbell.R")
source("3_visualize/src/viz_svi_sui.R")
source("3_visualize/src/viz_sui_popn.R")
source("3_visualize/src/viz_wq.R")
source("3_visualize/src/viz_ternary.R")
source("3_visualize/src/viz_availability.R")

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
                 tern_8 = "#F9D689",
                 dumbbell_sw = "#065867",
                 dumbbell_gw = "#F09300"))),
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
  tar_target(p3_colors_wq,
             p3_colors_website |> bind_cols(
               tibble(
                 # Wq loads 
                 very_low_col = "#E7CAE1",
                 low_col = "#D585A9", 
                 moderate_col = "#93658E", 
                 high_col = "#554C7A",
                 very_high_col = "#270C3F"
               ))),
  tar_target(p3_popn_colors,
             col_pal <- c("Severe" = p3_colors_balance$dry_red_dark, 
                          "High" = p3_colors_balance$dry_red_light, 
                          "Moderate" = p3_colors_balance$svg_col_default, 
                          "Low" = p3_colors_balance$wet_blue_light, 
                          "Very low/\nnone" = p3_colors_balance$wet_blue_dark)),
  
  tar_target(p3_fonts_website,
             tibble(
               legend_font = "Source Sans 3",
               supporting_font = "Source Sans 3",
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
  tar_target(p3_Reg_json,
             p2_Reg_sf |>
               select(-Shape_Area, -Shape_Leng, -Name, -Region, -AggRegion) |>
               ms_simplify(keep = 0.05) |>
               topojson_write(group = Region_nam, 
                              precision = 6,
                              file = "public/assets/Regions.topojson")
             ),
  
  ##############################################
  # 
  #           KEY TAKEAWAY 1: 
  #             
  #
  ## National water stress map
  tar_target(p3_map_stress_png,
             map_stress(in_sf = p2_HUC12_join_sui_svi_sf,
                        color_scheme = p3_colors_balance,
                        in_regions = p2_Reg_sf,
                        png_out = "src/assets/images/R/01_stress_map.png",
                        width = 8, height = 6)),
  ## Replicate maps for each water stress category
  tarchetypes::tar_map( 
    values = tibble::tibble(level = c("low", "very_low_none", "moderate", "severe", "high")),
    tar_target(p3_map_stress_levels_png,
               map_stress(in_sf = p2_HUC12_join_sui_svi_sf |>
                            dplyr::filter(sui_cat_clean == level),
                          in_regions = p2_Reg_sf,
                          color_scheme = p3_colors_balance,
                          png_out = sprintf("public/assets/01_stress_map_%s.png", level),
                          width = 8, height = 6)),
    names = level
          ),
  
  
  ##############################################
  # 
  #           KEY TAKEAWAY 2: 
  #             More than 30 million people live in areas of 
  #             high/severe water imbalance
  #
  #
    tar_target(p3_popn_circles_png,
               viz_popn_circles(in_df = p2_sui_popn_df,
                                color_scheme = p3_popn_colors,
                                png_out = "src/assets/images/R/02_sui_popn_CONUS.png",
                                width = 6,
                                height = 6),
               format = "file"
  ),
  tar_target(p3_popn_bar_vert_png,
             viz_popn_bar_vert(in_df = p2_popn_bar_df, 
                               color_scheme = p3_popn_colors, 
                               fonts = p3_fonts_website,
                               png_out = "src/assets/images/R/02_sui_popn_vert_bar.png",
                               width = 2,
                               height = 6),
             format = "file"
  ),
  tar_target(p3_popn_bar_hori_png,
             viz_popn_bar_hori(in_df = p2_popn_bar_df, 
                               color_scheme = p3_popn_colors, 
                               fonts = p3_fonts_website,
                               png_out = "src/assets/images/R/02_sui_popn_hori_bar.png",
                               width = 6,
                               height = 2),
             format = "file"
  ),
  tar_map(
    values = tibble::tibble(wa_types = c("wa_sw_wq", "wa_sui", "wa_gw_wq", "wa_ecoflow")),
    tar_target(p3_water_avail_png,
               water_avail_map(in_df = p2_water_avail_sf, 
                               wa_type = wa_types, 
                               color_scheme = p3_colors_website, 
                               png_out = sprintf("src/assets/images/R/02_water_avail_%s.png", wa_types), 
                               width = 6, height = 4),
               format = "file"
    ),
    names = wa_types
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
                              png_out = "src/assets/images/R/03_sui_svi_map.png",
                              width = 6, 
                              height = 5),
             format = "file"),
  tar_target(p3_map_dry_sui_svi_png,
             compose_svi_plot(in_map = p3_map_dry_sui_svi_grob,
                              legend_n = p3_legend_n_grob,
                              legend_prop = p3_legend_prop_grob,
                              legend_explain = p3_legend_explainer_grob,
                              png_out = "src/assets/images/R/03_sui_svi_dry_map.png",
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
    values = tibble::tibble(nutrient = c("tn", "tp"),
                            title = c("Increasing nitrogen load",
                                      "Increasting phosphorus load")),
    tar_target(p3_wq_map_HUC12_png,
               map_wq(in_sf = p2_HUC12_join_wq_sf,
                      nutrient = nutrient,
                      color_scheme = p3_colors_wq, 
                      regions_sf = p2_Reg_sf,
                      regions_fill = p3_colors_website,
                      plot_margin = 0.0009, 
                      bkgd_color = "transparent",
                      leg_title = title,
                      png_out = sprintf("src/assets/images/R/05_%s_map.png", nutrient),
                      width = 9, height = 6)),
    names = nutrient
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
  tar_map(
    values = tibble::tibble(tern_side = c("ps_ir", "ps_te", "te_ir", "all")),
    tar_target(p3_ternary_map_CONUS_png,
               ternary_map(in_sf = p2_HUC8_join_wu_sf,
                           tern_side = tern_side,
                           color_scheme = p3_colors_website,
                           width = 8,
                           height = 6,
                           png_out = sprintf("src/assets/images/R/08_wu_ternary_%s.png", tern_side)), 
               format = "file"),
    names = tern_side
  ),
  tar_target(p3_ternary_legend_ps_ir_png,
             ternary_legend(tern_side_pal = tibble::tibble(ps_ir = c("#952D3D", "#C63C51", "#E0896D", "#F9D689", "#BBA167")), 
                            left_label = "Increasing PS Use", 
                            right_label = "Increasing IR Use",
                            png_out = "src/assets/images/R/08_wu_ternary_legend_ps_ir.png")
  ),
  tar_target(p3_ternary_legend_ps_te_png,
             ternary_legend(tern_side_pal = tibble::tibble(ps_te = c("#952D3D", "#C63C51", "#705E70", "#53697A", "#3E4F5C")), 
                            left_label = "Increasing PS Use", 
                            right_label = "Increasing TE Use",
                            png_out = "src/assets/images/R/08_wu_ternary_legend_ps_te.png")
  ),
  tar_target(p3_ternary_legend_te_ir_png,
             ternary_legend(tern_side_pal = tibble::tibble(te_ir = c("#3E4F5C", "#53697A", "#637B73", "#F9D689", "#BBA167")), 
                            left_label = "Increasing TE Use", 
                            right_label = "Increasing IR Use",
                            png_out = "src/assets/images/R/08_wu_ternary_legend_te_ir.png")
  ),
    tar_target(p3_ternary_plot_png,
               ternary_plot(in_df = p2_wu_ternary_df,
                            width = 8,
                            height = 8,
                            png_out = "src/assets/images/R/08_wu_legend.png"), 
               format = "file"),
  tar_map(
    values = tibble::tibble(reg = c("Western", "High Plains", "Southeast", "Northeast through Midwest", "CONUS")),
    tar_target(p3_dumbbell_png,
               dumbbell_gw_v_sw(in_sf = p2_HUC8_join_wu_sf, 
                                agg_reg = reg,
                                wu_type = "all", 
                                color_scheme = p3_colors_wu,
                                width = 6,
                                height = 4,
                                png_out = sprintf("src/assets/images/R/08_allWU_gw_sw_dumbbell_%s.png", reg)),
               format = "file"),
    tar_target(p3_te_dumbbell_png,
               dumbbell_gw_v_sw(in_sf = p2_HUC8_join_wu_sf, 
                                agg_reg = reg,
                                wu_type = "te", #"te", "ir", "ps"
                                color_scheme = p3_colors_wu,
                                width = 6,
                                height = 4,
                                png_out = sprintf("src/assets/images/R/08_TE_gw_sw_dumbbell_%s.png", reg)),
               format = "file"),
    tar_target(p3_ps_dumbbell_png,
               dumbbell_gw_v_sw(in_sf = p2_HUC8_join_wu_sf, 
                                agg_reg = reg,
                                wu_type = "ps", #"te", "ir", "ps"
                                color_scheme = p3_colors_wu,
                                width = 6,
                                height = 4,
                                png_out = sprintf("src/assets/images/R/08_PS_gw_sw_dumbbell_%s.png", reg)),
               format = "file"),
    tar_target(p3_ir_dumbbell_png,
               dumbbell_gw_v_sw(in_sf = p2_HUC8_join_wu_sf, 
                                agg_reg = reg,
                                wu_type = "ir", #"te", "ir", "ps"
                                color_scheme = p3_colors_wu,
                                width = 6,
                                height = 4,
                                png_out = sprintf("src/assets/images/R/08_IR_gw_sw_dumbbell_%s.png", reg)),
               format = "file"),
    names = reg
  )
  
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
