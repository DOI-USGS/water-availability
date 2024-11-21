source("2_process/src/process_region_shp.R")
source("2_process/src/process_WBD_GDB.R")
source("2_process/src/process_ps_dumbbell.R")
source("2_process/src/process_wq_data.R")
source("2_process/src/process_wu_data.R")
source("2_process/src/process_sui_data.R")
source("2_process/src/process_svi_data.R")
source("2_process/src/process_popn_data.R")

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
  tar_target(p2_CONUS_crosswalk_HUC12_df,
             readr::read_csv(p1_CONUS_crosswalk) |>
               filter(AggRegion_nam != "NULL") |>
               left_join(p2_region_name_xwalk, by = "Region_nam")),
  # Master crosswalk at the HUC8 level
  tar_target(p2_CONUS_crosswalk_HUC8_df,
             p2_CONUS_crosswalk_HUC12_df |>
               group_by(HUC8) |>
               reframe(AggRegion_nam = unique(AggRegion_nam),
                       Region_nam = unique(Region_nam)) ),
  
  
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
               inner_join(p2_CONUS_crosswalk_HUC8_df, by = "HUC8") |>
               filter(! is.na(Region_nam)) 
  ),
  tar_target(p2_mainstem_HUC12_simple_sf,
             p1_mainstem_HUC12_raw_sf |> 
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
               rename(HUC12 = HUC) |>
               # remove everything outside of CONUS for now
               filter(region_group == "CONUS") |>
               st_intersection(st_union(p2_Reg_sf)) |>
               # add in region names
               inner_join(p2_CONUS_crosswalk_HUC12_df, by = "HUC12") |>
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
                                by = "HUC8") |>
               dplyr::left_join(p2_wu_ternary_df,
                                by = "HUC8")
  ),
  # Join with water use data
  tar_target(p2_HUC8_join_wu_AggRegGrp_sf,
             p2_HUC8_join_wu_sf |> 
               group_by(AggRegion_nam) |>
               tar_group(),
             iteration = "group"),
  
  # Join with SUI/water stress and SVI/vulnerability indices
  tar_target(p2_HUC12_join_sui_svi_sf,
             p2_mainstem_HUC12_simple_sf |>
               # add in mean SUI 
               dplyr::left_join(p2_sui_2020_HUC12,
                                by = "HUC12") |>
               dplyr::left_join(p2_svi_mean_HUC12,
                                by = "HUC12") |>
               filter(! is.na(sui_category_5)) |> 
               dplyr::mutate(sui_cat_clean = case_when(sui_category_5 == "High" ~ "high",
                                                       sui_category_5 == "Low" ~ "low",
                                                       sui_category_5 == "Moderate" ~ "moderate",
                                                       sui_category_5 == "Severe" ~ "severe",
                                                       sui_category_5 == "Very low/\nnone" ~ "very_low_none"))
             
  ),

  # Join with water quality data (loads)
  tar_target(p2_HUC8_join_wq_sf,
             p2_mainstem_HUC8_simple_sf |>
               # add in tn loads
               dplyr::left_join(p1_wq_HUC8_df_tn |> rename(tn_load = total_load), 
                                by = "HUC8") |>
               # add in tp loads
               dplyr::left_join(p1_wq_HUC8_df_tp |> rename(tp_load = total_load), 
                                by = "HUC8")),

  # Join with water availability for key finding 2
  tar_target(p2_water_avail,
    tibble(
      Region_nam = c("Northeast", "Atlantic Coast", "Florida", 
                  "Great Lakes", "Midwest", "Tennessee-Missouri",  
                  "Mississippi Embayment", "Gulf Coast",   
                  "Souris-Red-Rainy", "Northern High Plains",
                  "Central High Plains", "Southern High Plains",
                  "Texas", "Columbia-Snake",
                  "Central Rockies", "Southwest Desert",
                  "Pacific Northwest", "California-Nevada"),
      wa_sui = c("very low", "low", "high", "very low", "moderate", "low", 
                 "severe", "moderate", "moderate", "moderate", "severe", "severe", 
                 "severe", "very low", "moderate", "high", "very low", "high"),
      wa_sw_wq = c("moderate", "moderate", "very low", "low", "severe", "high", 
                   "high", "low", "severe", "severe", "severe", "severe", 
                   "low", "moderate", "high", "high", "moderate", "high"),
      wa_gw_wq = c("moderate", "low", "very low", "moderate", "moderate", "low", 
                   "very low", "very low", "moderate", "low", "high", "severe", 
                   "high", "moderate", "low", "severe", "very low", "high"),
      wa_ecoflow = c("severe", "moderate", "severe", "low", "low", "moderate", 
                     "high", "high", "very low", "low", "severe", "high", 
                     "severe", "low", "very low", "very low", "moderate", "high")
    )
  ),
  tar_target(p2_water_avail_sf,
             p2_water_avail |> 
               dplyr::left_join(p2_Reg_sf,
                                by = "Region_nam")
  ),

  # Summarize SUI by state
  tar_target(p2_states_sui_df,
             summary_sui_by_state(in_sf = p2_HUC12_join_sui_svi_sf)),
  # write summary to csv
  tar_target(p2_states_sui_csv,
             readr::write_csv(p2_states_sui_df,
                              file = "public/sui_state.csv")),
  
  
  ##############################################
  # 
  #           WATER QUALITY DATA
  # 
  tar_target(p2_wq_threats_df,
             prep_wq_for_sankey(data_in = p1_wq_threats_csv,
                                unimpair_miles = p2_wq_unimpair_river_miles_tibble)),
  # Save to csv for d3
  tar_map(
    values = tibble(useType = c("DW", "Eco", "Fish", "Rec", "Other")),
    tar_target(p2_wq_threats_csv,
               {path_out = sprintf("public/wq_threats_%s.csv", useType)
                 readr::write_csv(p2_wq_threats_df |> dplyr::filter(UseAbbr == useType),
                                file = path_out)
                 return(path_out)},
               format = "file")),
  tar_target(p2_wq_threats_all_csv,
             {readr::write_csv(p2_wq_threats_df,
                              file = "public/wq_threats_all.csv")
               return("public/wq_threats_all.csv")},
             format = "file"),
  
  # Need a table of unimpaired river miles by water use, not in original data
  # but in a table from report (Table 5)
  tar_target(p2_wq_unimpair_river_miles_tibble,
             tribble(
               ~use_name, ~Category, ~parameter, ~sum_watersize,
               "Drinking Water Use", "Unimpaired", "Unimpaired", 184652,
               "Ecological Use", "Unimpaired", "Unimpaired", 508816,
               "Fish Consumption Use", "Unimpaired", "Unimpaired", 98021,
               "Recreational Use", "Unimpaired", "Unimpaired", 323983,
               "Other Use", "Unimpaired", "Unimpaired", 487640)),
  
  ##############################################
  # 
  #           WATER USE DATA
  #
  # Functions for all three uses
  tar_target(p2_wu_yearly_df,
             total_wu_yearly(p2_wu_ps_tot_raw,
                             p2_wu_te_tot_raw,
                             p2_wu_ir_tot_raw,
                             p2_wu_te_tot_saline_raw,
                             min_year = 2010,
                             max_year = 2020)
  ),
  tar_target(p2_wu_yearly_csv,
             {readr::write_csv(p2_wu_yearly_df,
                               file = "public/wu_yearly.csv")
               return("public/wu_yearly.csv")},
             format = "file"),
  tar_target(p2_wu_ternary_df,
             total_wu_proportions(ps_in = p2_wu_ps_mean2000to2020_HUC8,
                                  ir_in = p2_wu_ir_mean2000to2020_HUC8,
                                  te_in = p2_wu_te_mean2000to2020_HUC8,
                                  color_scheme = p3_colors_wu)),
  
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
  tar_target(p2_wu_te_tot_saline_raw,
             load_wu_data(data_path = p1_wu_te_tot_saline_csv,
                          use_type = "te",
                          source_type = "saline") |>
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
  tar_target(p2_sui_raw,
             readr::read_csv(p1_sui_csv,
                             show_col_types = FALSE)),

  # By HUC12 and Year
  tar_target(p2_sui_2020_HUC12,
             mean_sui(data_in = p2_sui_raw,
                      HUC_level = 12,
                      min_year = 2020, # should be 2010
                      max_year = 2020,
                      by_yearL = FALSE)),
  # water supply and demand for each region from Ted
  tar_target(p2_supply_v_demand_df,
             process_supply_v_demand(data_path = p1_supply_v_demand_csv)),
  tar_target(p2_supply_demand_csv,
             {readr::write_csv(p2_supply_v_demand_df,
                               file = "public/wa_supply_demand.csv")
               return("public/wa_supply_demand.csv")},
             format = "file"),
  tar_target(p2_water_stress_stats_csv,
             create_stats(in_sf = p2_HUC12_join_sui_svi_sf,
                          out_csv = "public/wa_stress_stats.csv")),
  
  ##############################################
  # 
  #           EXTERNAL DATA SOURCES
  # 
  # Social Vulnerability Index 
  tar_target(p2_svi_thresholds,
             tibble(
               lower = 0.4,
               upper = 0.6
             )),
  tar_target(p2_svi_raw,
             readr::read_csv(p1_svi_csv,
                             show_col_types = FALSE)),
  
  tar_target(p2_svi_mean_HUC12,
             mean_svi(data_in = p2_svi_raw,
                      HUC_level = 12,
                      thresholds = p2_svi_thresholds)),
  # Join SVI and SUI by category for tree map
  tar_target(p2_sui_svi_HUC12_df,
             join_svi_sui(sui_in = p2_sui_2020_HUC12,
                          svi_in = p2_svi_mean_HUC12,
                          HUC_level = 12)),
  
  # POPULATION DATA
  tar_target(p2_popn_HUC12_df,
             clean_popn_data(popn_in = p1_popn_csv,
                             crosswalk_in = p2_CONUS_crosswalk_HUC12_df)),
  # join sui with population data
  tar_target(p2_sui_popn_df,
             join_popn_to_sui(sui_in = p2_sui_2020_HUC12,
                              popn_in = p2_popn_HUC12_df)),
  tar_target(p2_popn_bar_df,
             popn_for_bar(in_df = p2_sui_popn_df))
  
)
