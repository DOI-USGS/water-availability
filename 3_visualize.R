source("3_visualize/src/svg_helpers.R")
source("3_visualize/src/viz_dumbbell.R")

p3_targets <- list(
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
               tern_8 = "#FEFFA7"
             )),
  ########################
  # SVG to overlay maps for website
  tar_target(p3_AggReg_svg,
             create_svg_for_web(in_sf = p2_AggRegion_sf,
                                identifier = "AggReg_nam_nospace",
                                width = 6, height = 9,
                                file_out = "src/assets/svgs/AggReg.svg"),
             format = "file"),
  tar_target(p3_Reg_svg,
             create_svg_for_web(in_sf = p2_Region_sf,
                                identifier = "Region_nam_nospace",
                                width = 6, height = 9,
                                file_out = "src/assets/svgs/Regions.svg"),
             format = "file"),
  
  ########################
  # Dumbbell charts to show gw versus sw by region and west/east
  tar_target(p3_ps_source_dumbbell_png,
             dumbbell_gw_v_sw(in_sf = p2_mainstem_HUC8_sf,
                              in_CONUS = p2_mainstem_HUC8_sf,
                              stacked_from_zeroL = FALSE, 
                              color_scheme = p3_colors_website,
                              width = 6,
                              height = 4,
                              png_out = "src/assets/images/ws_ps_dumbbell_centered_CONUS.png"),
             format = "file"),
  tar_target(p3_ps_source_dumbbell_AggReg_png,
             dumbbell_gw_v_sw(in_sf = p2_mainstem_HUC8_AggRegionGroup_sf,
                              in_CONUS = p2_mainstem_HUC8_sf,
                              stacked_from_zeroL = FALSE, 
                              color_scheme = p3_colors_website,
                              width = 6,
                              height = 4,
                              png_out = sprintf("src/assets/images/ws_ps_dumbbell_centered_%s.png",
                                                unique(p2_mainstem_HUC8_AggRegionGroup_sf$AggRegion_nam))),
             pattern = p2_mainstem_HUC8_AggRegionGroup_sf,
             format = "file")
)
