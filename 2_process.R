source("2_process/src/process_region_shp.R")
source("2_process/src/process_WBD_GDB.R")
source("2_process/src/process_ps_dumbbell.R")

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
             p2_Reg_sf |> group_by(AggReg_nam) |> summarize() |>
               left_join(p2_region_name_xwalk, by = "AggReg_nam")),
  
  # Shapefiles for plotting
  tar_target(p2_mainstem_HUC8_raw_sf,
             prep_sf(huc_path = p1_CONUS_mainstem_zip,
                     layer = "WBDHU8", 
                     crs_out = p1_usgs_crs,
                     exclude_non_plot_hucs = TRUE)),
  tar_target(p2_mainstem_HUC8_simple_sf,
             p2_mainstem_HUC8_raw_sf |> 
               mutate(
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
               # add in region names
               left_join(p1_CONUS_crosswalk_HUC8_df, by = "HUC8")
  ),
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  tar_target(p2_mainstem_HUC8_sf,
             p2_mainstem_HUC8_simple_sf |>
             # add in public supply water use data 
               left_join(p2_wu_ps_gw_wy2020_HUC8, by = "HUC8") 
  ),
  tar_target(p2_mainstem_HUC8_AggRegGroup_sf,
             p2_mainstem_HUC8_sf |> 
               group_by(AggRegion_nam) |>
               tar_group(),
             iteration = "group"),
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  # PUBLIC SUPPLY 
  
  # Calculate public supply source summary by HUC 8
  # raw format: row for each HUC12 and columns for every month, plus
  #     source, use, huc12 name, region name, and aggregated region name
  tar_target(p2_wu_ps_gw_raw,
             readr::read_csv(p1_wu_ps_gw_csv,
                             show_col_types = FALSE) |>
               filter(AggRegion_nam != "NULL") |>
               mutate(use = "Public Supply")),
  tar_target(p2_wu_ps_sw_raw,
             readr::read_csv(p1_wu_ps_sw_csv,
                             show_col_types = FALSE) |>
               filter(AggRegion_nam != "NULL") |>
               mutate(use = "Public Supply")),
  tar_target(p2_wu_ps_gw_wy2020_HUC8,
             prep_for_dumbbell(raw_gw_in = p2_wu_ps_gw_raw,
                               raw_sw_in = p2_wu_ps_sw_raw,
                               water_year = 2020) 
  )
  

)