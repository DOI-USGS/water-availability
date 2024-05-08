source("3_visualize/src/svg_helpers.R")
source("3_visualize/src/viz_dumbbell.R")

p3_targets <- list(
  ##############################################
  # 
  #           GLOBAL THEMES
  # 
  # Color theme
  tar_target(p3_colors_website,
             tibble(
               te_gw_main = "#01A0C7", #tern_5
               te_sw_secondary = "#1687A5",
               te_saline = "#01F9C6",
               ir_gw_main = "#FDFF01", #tern_9
               ir_sw_secondary = "#D0CB02",
               ps_gw_main = "#F41A90", #tern_1
               ps_secondary = "#C72873",
               tern_2 = "#73A8D2",
               tern_3 = "#FD7FBA",
               tern_4 = "#FEB4A6",
               tern_6 = "#3FBAD2",
               tern_7 = "#85CAC3",
               tern_8 = "#FEFFA7",
               wu_sw = "#065867",
               wu_gw = "#F09300",
               svg_fill_default = "#d1cdc0",
               svg_col_default = "#edeadf" # background color of page
             )),
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
  #           KEY TAKEAWAY 3: 
  #             Almost 30 million people live in areas of 
  #             high/severe water stress.
  #
  #
  
  ##############################################
  # 
  #           KEY TAKEAWAY 4: 
  #             A high proportion of the population living 
  #             in areas with water availability limitations 
  #             are considered to be socially vulnerable.
  #
  #
  
  ##############################################
  # 
  #           KEY TAKEAWAY 5: 
  #             Human activities can affect water quality through 
  #             inputs (e.g., organic chemicals), processes 
  #             (e.g., dredging), or permanent landscape modifications 
  #             (e.g., dams, urbanization).
  #
  #
  
  
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
  # Dumbbell charts to show gw versus sw by region and west/east
  tar_target(p3_k08_wu_ps_source_dumbbell_png,
             dumbbell_gw_v_sw(in_sf = p2_mainstem_HUC8_sf,
                              in_CONUS = p2_mainstem_HUC8_sf,
                              stacked_from_zeroL = FALSE, 
                              color_scheme = p3_colors_website,
                              width = 6,
                              height = 4,
                              png_out = "src/assets/images/k08_ws_ps_dumbbell_centered_CONUS.png"),
             format = "file"),
  tar_target(p3_k08_wu_ps_source_dumbbell_AggReg_png,
             dumbbell_gw_v_sw(in_sf = p2_mainstem_HUC8_AggRegGroup_sf,
                              in_CONUS = p2_mainstem_HUC8_sf,
                              stacked_from_zeroL = FALSE, 
                              color_scheme = p3_colors_website,
                              width = 6,
                              height = 4,
                              png_out = sprintf("src/assets/images/k08_ws_ps_dumbbell_centered_%s.png",
                                                unique(p2_mainstem_HUC8_AggRegGroup_sf$AggRegion_nam))),
             pattern = p2_mainstem_HUC8_AggRegGroup_sf,
             format = "file")
  
  ##############################################
  # 
  #           KEY TAKEAWAY 9: 
  #             Periods of low precipitation (snow, rain) can have 
  #             cascading effects throughout the water budget, 
  #             expanding areas of water stress and exacerbating 
  #             water quality issues.
  # 
  
  ##############################################
  # 
  #           KEY TAKEAWAY 10: 
  #             Areas of the U.S. with limited surface water storage 
  #             rely on groundwater, which can lead to declines in 
  #             water levels.
  # 
)
