source("2_process/src/process_region_shp.R")
source("2_process/src/process_WBD_GDB.R")
source("2_process/src/process_ps_dumbbell.R")
source("2_process/src/process_wu_data.R")
source("2_process/src/process_sui_data.R")

p2_targets <- list(
  ##############################################
  # 
  #           GLOBAL DATA
  # 
  # Master tibbles for cross-referencing region names, numbers
  tar_target(p2_region_name_xwalk,
             tibble(
               Region = 1:18,
               Region_nam = c("Northeast", "Atlantic Coast", "Florida", 
                              "Great Lakes", "Midwest", "Tennessee-Missouri",  
                              "Mississippi Embayment", "Gulf Coast",   
                              "Souris-Red-Rainy", "Northern High Plains",
                              "Central High Plains", "Southern High Plains",
                              "Texas", "Columbia-Snake",
                              "Central Rockies", "Southwest Desert",
                              "Pacific Northwest", "California-Nevada"),
               Region_nam_nospace = stringr::str_replace_all(Region_nam, pattern = " ", replacement = "_"),
               AggRegion = as.factor(c(2, 3, 3, 2, 2, 3, 3, 3, 2, 1, 1, 1, 3, 4, 4, 4, 4, 4)),
               AggReg_nam = c("Northeast through Midwest", "Southeast", "Southeast",
                              "Northeast through Midwest", "Northeast through Midwest",
                              "Southeast", "Southeast", "Southeast", 
                              "Northeast through Midwest", "High Plains", 
                              "High Plains", "High Plains", "Western", "Western",
                              "Western", "Western", "Western", "Western"),
               AggReg_nam_nospace = stringr::str_replace_all(AggReg_nam, 
                                                             pattern = " ", 
                                                             replacement = "_")
             )
  ),
  # Master crosswalk at the HUC12 level
  tar_target(p1_CONUS_crosswalk_HUC12_df,
             readr::read_csv(p1_CONUS_crosswalk, skip = 1)|>
               filter(AggRegion_nam != "NULL")),
  # Master crosswalk at the HUC8 level
  tar_target(p1_CONUS_crosswalk_HUC8_df,
             p1_CONUS_crosswalk_HUC12_df |>
               group_by(HUC8) |>
               reframe(AggRegion_nam = unique(AggRegion_nam),
                       Region_nam = unique(Region_nam))),
  
  
  ##############################################
  # 
  #           SPATIAL DATA
  # 
  # Create regions sf, simplified
  tar_target(p2_Reg_sf,
             regions_to_sf(in_shp = p1_Reg_shp) |>
               left_join(p2_region_name_xwalk, by = "Region")),
  tar_target(p2_AggReg_sf,
             p2_Reg_sf |>
               group_by(AggReg_nam) |>
               summarize() |>
               left_join(p2_region_name_xwalk, by = "AggReg_nam")),
  
  # Shapefiles for plotting
  tar_target(p2_mainstem_HUC8_simple_sf,
             p1_mainstem_HUC8_raw_sf |> 
               dplyr::mutate(
                 HUC2 = str_sub(HUC, 1, 2),
                 region_group = case_when(
                   HUC2 == "19" ~ "AK",
                   HUC2 == "20" ~ "HI",
                   HUC2 == "21" ~ "PR",
                   HUC2 == "22" ~ "other",
                   .default = "CONUS"
                 )
               ) |> 
               rename(HUC8 = HUC) |>
               # remove everything outside of CONUS for now
               filter(region_group == "CONUS") |>
               st_intersection(st_union(p2_Reg_sf)) |>
               # add in region names
               inner_join(p1_CONUS_crosswalk_HUC8_df, by = "HUC8") |>
               filter(! is.na(Region_nam)) 
  ),
  
  ##################################################
  # Join spatial data with water data 
  tar_target(p2_HUC8_join_wu_sf,
             p2_mainstem_HUC8_simple_sf |>
               # add in mean water use data 
               dplyr::left_join(p2_wu_te_mean2000to2020_HUC8, 
                                by = "HUC8") |>
               dplyr::left_join(p2_wu_ps_mean2000to2020_HUC8, 
                                by = "HUC8") |>
               dplyr::left_join(p2_wu_ir_mean2000to2020_HUC8, 
                                by = "HUC8") 
  ),
  # Join with water use data
  tar_target(p2_HUC8_join_wu_AggRegGrp_sf,
             p2_HUC8_join_wu_sf |> 
               group_by(AggRegion_nam) |>
               tar_group(),
             iteration = "group"),
  
  # Join with SUI/water stress and SVI/vulnerability indices
  tar_target(p2_HUC8_join_sui_svi_sf,
             p2_mainstem_HUC8_simple_sf |>
               # add in mean SUI 
               dplyr::left_join(p2_sui_mean_HUC8,
                                by = "HUC8") |>
               dplyr::left_join(p2_sui_yearly_HUC8, 
                                by = "HUC8") |>
               dplyr::left_join(p2_svi_mean_HUC8,
                                by = "HUC8")
             
  ),
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  # Public water supply
  tar_target(p2_wu_ps_gw_raw,
             load_wu_data(data_path = p1_wu_ps_gw_csv,
                          use_type = "ps",
                          source_type = "gw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ps_sw_raw,
             load_wu_data(data_path = p1_wu_ps_sw_csv,
                          use_type = "ps",
                          source_type = "sw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ps_tot_raw,
             load_wu_data(data_path = p1_wu_ps_tot_csv,
                          use_type = "ps",
                          source_type = "total") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ps_mean2000to2020_HUC8,
             mean_wu_HUC8(p2_wu_ps_gw_raw,
                          p2_wu_ps_sw_raw,
                          p2_wu_ps_tot_raw,
                          min_year = 2010,
                          max_year = 2020) 
  ),
  # Irrigation
  tar_target(p2_wu_ir_gw_raw,
             load_wu_data(data_path = p1_wu_ir_gw_csv,
                          use_type = "ir",
                          source_type = "gw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ir_sw_raw,
             load_wu_data(data_path = p1_wu_ir_sw_csv,
                          use_type = "ir",
                          source_type = "sw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ir_tot_raw,
             load_wu_data(data_path = p1_wu_ir_tot_csv,
                          use_type = "ir",
                          source_type = "total") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_ir_mean2000to2020_HUC8,
             mean_wu_HUC8(p2_wu_ir_gw_raw,
                          p2_wu_ir_sw_raw,
                          p2_wu_ir_tot_raw,
                          min_year = 2010,
                          max_year = 2020) 
  ),
  # Thermoelectric
  tar_target(p2_wu_te_gw_raw,
             load_wu_data(data_path = p1_wu_te_gw_csv,
                          use_type = "te",
                          source_type = "gw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_te_sw_raw,
             load_wu_data(data_path = p1_wu_te_sw_csv,
                          use_type = "te",
                          source_type = "sw") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_te_tot_raw,
             load_wu_data(data_path = p1_wu_te_tot_csv,
                          use_type = "te",
                          source_type = "total") |>
               filter(AggRegion_nam != "NULL")),
  tar_target(p2_wu_te_mean2000to2020_HUC8,
             mean_wu_HUC8(p2_wu_te_gw_raw,
                          p2_wu_te_sw_raw,
                          p2_wu_te_tot_raw,
                          min_year = 2010,
                          max_year = 2020) 
  ),
  
  ##############################################
  # 
  #           WATER BALANCE DATA
  # 
  # WATER STRESS INDEX "SURFACE WATER SUPPLY AND USE INDEX" SUI
  tar_target(p2_sui_thresholds,
             tibble(
               lower = 0.5, # 0.4 for 3 categories to match IWAAs
               upper = 1.0, # 0.6 for 3 categories to match IWAAs
             )),
  tar_target(p2_sui_raw,
             readr::read_csv(p1_sui_csv,
                             show_col_types = FALSE)),
  # mean by HUC8
  tar_target(p2_sui_mean_HUC8,
             mean_sui(data_in = p2_sui_raw,
                      thresholds = p2_sui_thresholds,
                      min_year = 2010,
                      max_year = 2020,
                      HUC_level = 8)
  ),
  # By HUC8 and Year
  tar_target(p2_sui_yearly_HUC8,
             mean_sui_by_year(data_in = p2_sui_raw,
                              HUC_level = 8)),
  
  ##############################################
  # 
  #           EXTERNAL DATA SOURCES
  # 
  # Social Vulnerability Index 
  tar_target(p2_svi_thresholds,
             tibble(
               lower = 0.5,
               upper = 1.0
             )),
  tar_target(p2_svi_raw,
             readr::read_csv(p1_svi_csv,
                             show_col_types = FALSE)),
  
  tar_target(p2_svi_mean_HUC8,
             p2_svi_raw |> 
               mutate(HUC8 = substr(HUC12, 1, 8)) |>
               group_by(HUC8) |>
               summarize(mean_svi = mean(overall_weighted_SVI, na.rm = TRUE),
                         mean_svi_theme1 = mean(theme1_weighted_SVI, na.rm = TRUE),
                         mean_svi_theme2 = mean(theme2_weighted_SVI, na.rm = TRUE),
                         mean_svi_theme3 = mean(theme3_weighted_SVI, na.rm = TRUE),
                         mean_svi_theme4 = mean(theme4_weighted_SVI, na.rm = TRUE)) |>
               mutate(svi_category = case_when(mean_svi <= p2_svi_thresholds$lower ~ "Low SVI",
                                               mean_svi <= p2_svi_thresholds$upper ~ "High SVI",
                                               mean_svi <= 1.0 ~ "Severe SVI",
                                               TRUE ~ NA),
                      svi1_category = case_when(mean_svi_theme1 <= p2_svi_thresholds$lower ~ "Low SVI",
                                                mean_svi_theme1 <= p2_svi_thresholds$upper ~ "High SVI",
                                                mean_svi_theme1 <= 1.0 ~ "Severe SVI",
                                                TRUE ~ NA),
                      svi2_category = case_when(mean_svi_theme2 <= p2_svi_thresholds$lower ~ "Low SVI",
                                                mean_svi_theme2 <= p2_svi_thresholds$upper ~ "High SVI",
                                                mean_svi_theme2 <= 1.0 ~ "Severe SVI",
                                                TRUE ~ NA),
                      svi3_category = case_when(mean_svi_theme3 <= p2_svi_thresholds$lower ~ "Low SVI",
                                                mean_svi_theme3 <= p2_svi_thresholds$upper ~ "High SVI",
                                                mean_svi_theme3 <= 1.0 ~ "Severe SVI",
                                                TRUE ~ NA),
                      svi4_category = case_when(mean_svi_theme4 <= p2_svi_thresholds$lower ~ "Low SVI",
                                                mean_svi_theme4 <= p2_svi_thresholds$upper ~ "High SVI",
                                                mean_svi_theme4 <= 1.0 ~ "Severe SVI",
                                                TRUE ~ NA))),
  # Join SVI and SUI by category for tree map
  tar_target(p2_sui_svi_HUC8_df,
             join_svi_sui(sui_in = p2_sui_mean_HUC8,
                          svi_in = p2_svi_mean_HUC8))
  
)