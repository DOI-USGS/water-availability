source("2_process/src/process_region_shp.R")
source("2_process/src/process_WBD_GDB.R")
source("2_process/src/process_ps_dumbbell.R")
source("2_process/src/process_ws_data.R")
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
  # Master aquifer crosswalk 
  tar_target(p2_aquifer_name_xwalk,
             #   x = x positioning of label in cowplot
             #   y = y positioning of label in cowplot
             #   row and col = geofacet positions
             tibble::tribble(
               ~abbr, ~x, ~y, ~full_name, ~code, ~row, ~col, 
               "cacb", 0.1,0.6,       "CA Coastal Basins",       1, 4, 1,
               "cval", 0.1,0.34,       "Central Valley",                 2, 3, 1,
               "clpt", 0.1,0.88,        "Columbia Plateau Basalts", 3, 1, 1,
               "bnrf", 0.27,0.33,       "Basin and Range Fill",     4, 4, 2,
               "bnrc", 0.25,0.63,       "Basin and Range Carbonates", 5, 3, 2,
               "copl", 0.38,0.48,       "Colorado Plateau",           6, 3, 3,
               "hpaq", 0.5,0.62,        "High Plains",                7, 2, 4,
               "strv1", 0.62,0.58,      "Stream Valley - West",         8, 3, 5,
               "rgaq", 0.45,0.42,       "Rio Grande",                 9, 5, 3,
               "edtr", 0.39,0.28,       "Edwards - Trinity",            10, 5, 4,
               "ozrk", 0.58,0.46,       "Ozarks",                     13, 4, 6,
               "metx", 0.35,0.13,       "MS Embayment, TX Coastal Uplands", 14, 6, 5,
               "secp", 0.88,0.4,       "Southeast Coastal Plain",   15, 4, 9,
               "strv2", 0.73,0.62,      "Stream Valley - East",           16, 3, 9,
               "cmor",  0.7,0.72,      "Cambrian - Ordovician",          17, 2, 6,
               "glac",  0.5,0.85,      "Glacial",                      18, 1, 5,
               "vpdc",  0.88,0.75,      "Valley and Ridge, Piedmont and Blue Ridge", 19, 2, 10,
               "pied",  0.73,0.52,      "Piedmont - Blue Ridge Crystalline", 20, 4, 8,
               "nacp",  0.93,0.48,      "North Atlantic Coastal Plain", 21, 3, 10,
               "surf",  0.88,0.3,      "Surficial",                22, 5, 9, 
               "bisc",  0.88,0.13,      "Biscayne",                   23, 6, 9,
               "flor",  0.7,0.35,      "Floridan",                   24, 5, 8,
               "clow",  0.6,0.22,      "Coastal Lowlands",           25, 5, 7
             )),
  
  
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
               filter(region_group == "CONUS") 
  ),
  
  # simplified for small inset maps
  tar_target(
    p2_State_sf,
    p2_State_detailed_sf |>
      ms_simplify()
  ),
  # not simplified, for more detailed maps
  tar_target(
    p2_State_detailed_sf,
    {
      tigris::states(cb = TRUE) |>
        rmapshaper::ms_simplify() |> 
        sf::st_transform(st_crs(p2_Reg_sf)) |>
        filter(!(STUSPS %in% c('AS','GU','VI', 'HI','AK', 'PR', 'MP'))) |>
        select(STUSPS, NAME) |>
        group_by(STATES = STUSPS, NAME) |>
        summarize() |>
        mutate(name_clean = gsub(' ', '_', NAME))
    }
  ),
  
  ##################################################
  # Join spatial data with water data 
  tar_target(p2_HUC12_join_wu_sf,
             p2_mainstem_HUC12_simple_sf |>
               # needed for dumbbell
               dplyr::left_join(p2_wu_ternary_df,
                                by = "HUC12") |>
               # add in mean water use data 
               dplyr::left_join(p2_wu_te_saline_mean2000to2020_HUC12 |>
                                  select(HUC12, te_saline),
                                by = "HUC12")
  ),
  # Join with water use data
  tar_target(p2_HUC12_join_wu_AggRegGrp_sf,
             p2_HUC12_join_wu_sf |> 
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
  tar_target(p2_HUC12_join_wq_sf,
             p2_mainstem_HUC12_simple_sf |>
               # add in tn loads
               dplyr::left_join(p2_wq_HUC12_df_tn |> rename(tn_load = total_load), 
                                by = "HUC12") |>
               # add in tp loads
               dplyr::left_join(p2_wq_HUC12_df_tp |> rename(tp_load = total_load), 
                                by = "HUC12")),

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

  ### Spatial summaries for d3 charts
  
  # Summarize WU by state
  tar_target(p2_states_wu_df,
             summary_wu_by_state(in_sf = p2_HUC12_join_wu_AggRegGrp_sf)),  
  # write WU state summary to csv
  tar_target(p2_states_wu_csv,
             readr::write_csv(p2_states_wu_df,
                              file = "public/wu_state.csv")),
  # Summarize WU by Region
  tar_target(p2_Reg_wu_df,
             summary_wu_by_Reg(in_sf = p2_HUC12_join_wu_AggRegGrp_sf)),  
  # write WU regional summary to csv
  tar_target(p2_Reg_wu_csv,
             readr::write_csv(p2_Reg_wu_df,
                              file = "public/wu_regions.csv")),
  
  # Summarize SUI by state
  tar_target(p2_states_sui_df,
             summary_sui_by_state(in_sf = p2_HUC12_join_sui_svi_sf)),
  # write summary to csv
  tar_target(p2_states_sui_csv,
             readr::write_csv(p2_states_sui_df,
                              file = "public/sui_state.csv")),
  # summarize SUI by region
  tar_target(p2_water_stress_stats_csv,
             create_stats(in_sf = p2_HUC12_join_sui_svi_sf,
                          out_csv = "public/wa_stress_stats.csv")),
  
  # Summarize WQ water quality
  tarchetypes::tar_map(
    values = tibble::tibble(nutrient = c("tn", "tp")),
    tar_target(p2_states_wq_csv,
               summary_wq_by_area(in_sf = p2_HUC12_join_wq_sf,
                                   nutrient = nutrient,
                                   out_csv = sprintf("public/wq_loads_state_%s.csv", nutrient),
                                   by = "state"),
               format = 'file'),
    tar_target(p2_Reg_wq_csv,
               summary_wq_by_area(in_sf = p2_HUC12_join_wq_sf,
                                   nutrient = nutrient,
                                   out_csv = sprintf("public/wq_loads_Reg_%s.csv", nutrient),
                                   by = "region"),
               format = 'file'),
    names = nutrient
  ),

  
  ##############################################
  # 
  #           WATER SUPPLY DATA
  # 
  # Change water supply data into long format
  tar_target(p2_ws_precip_df,
         compare_ws_mean(data_in = p1_ws_precip_csv,
                         supply_name = "precip",
                         min_year = 2010,
                         max_year = 2020,
                         xwalk = p2_CONUS_crosswalk_HUC12_df)),
  tar_target(p2_ws_et_df,
             compare_ws_mean(data_in = p1_ws_et_csv,
                             supply_name = "et",
                             min_year = 2010,
                             max_year = 2020,
                             xwalk = p2_CONUS_crosswalk_HUC12_df)),
  tar_target(p2_ws_sm_df,
             compare_ws_mean(data_in = p1_ws_sm_csv,
                             supply_name = "sm",
                             min_year = 2010,
                             max_year = 2020,
                             xwalk = p2_CONUS_crosswalk_HUC12_df)),
  tar_target(p2_ws_sf_df,
             compare_ws_mean(data_in = p1_ws_sf_csv,
                             supply_name = "sf",
                             min_year = 2010,
                             max_year = 2020,
                             xwalk = p2_CONUS_crosswalk_HUC12_df)),
  # join together
  tar_target(p2_ws_all_df,
             bind_rows(p2_ws_precip_df,
                       p2_ws_et_df,
                       p2_ws_sm_df,
                       p2_ws_sf_df)),
  
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
  
  # Total nitrogen and phosphorus loads
  tar_map(
    values = tibble::tibble(raw_targets = rlang::syms(c("p1_load_tn", "p1_load_tp")),
                            nutrient = c("tn", "tp")),
    # loads by category
    tar_target(p2_wq_Reg_df,
               process_wq_data(in_csv = raw_targets,
                               nutrient = nutrient)),
    # total loads by HUC12 and HUC8
    tar_target(p2_wq_HUC12_df,
               process_wq_HUC12(in_csv = raw_targets,
                              in_COMID_xwalk = p1_COMID_to_HUC12_crosswalk_csv)),
    tar_target(p2_wq_Reg_d3_csv,
               readr::write_csv(p2_wq_Reg_df,
                                file = sprintf("public/wq_sources_%s.csv", nutrient))),
    names = nutrient
  ),

  
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
  # needed for dumbbell charts
  tar_target(p2_wu_ternary_df,
             total_wu_proportions(ps_in = p2_wu_ps_mean2000to2020_HUC12,
                                  ir_in = p2_wu_ir_mean2000to2020_HUC12,
                                  te_in = p2_wu_te_mean2000to2020_HUC12,
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
  tar_target(p2_wu_ps_mean2000to2020_HUC12,
             mean_wu_HUC12(p2_wu_ps_gw_raw,
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
  tar_target(p2_wu_ir_mean2000to2020_HUC12,
             mean_wu_HUC12(p2_wu_ir_gw_raw,
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
  tar_target(p2_wu_te_mean2000to2020_HUC12,
             mean_wu_HUC12(p2_wu_te_gw_raw,
                          p2_wu_te_sw_raw,
                          p2_wu_te_tot_raw,
                          min_year = 2010,
                          max_year = 2020) 
  ),
  tar_target(p2_wu_te_saline_mean2000to2020_HUC12,
             mean_wu_HUC12(p2_wu_te_tot_saline_raw,
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

  # Average annual water limitation
  tar_target(p2_sui_2020_HUC12,
             mean_sui(data_in = p2_sui_raw,
                      HUC_level = 12,
                      min_year = 2010, 
                      max_year = 2020,
                      by_yearL = FALSE)),
  # Monthly water limitation, national basis
  tar_target(p2_sui_monthly_CONUS,
             monthly_sui(data_in = p2_sui_raw)),
  # water supply and demand for each region from Ted
  tar_target(p2_supply_v_demand_df,
             process_supply_v_demand(data_path = p1_supply_v_demand_csv)),
  tar_target(p2_supply_demand_csv,
             {readr::write_csv(p2_supply_v_demand_df,
                               file = "public/wa_supply_demand.csv")
               return("public/wa_supply_demand.csv")},
             format = "file"),
  
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
