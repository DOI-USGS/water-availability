source("1_fetch/src/sb_fetch_helpers.R")



p1_targets <- list(
  ##############################################
  # 
  #          SPATIAL DATA
  # 
  # Download shapefiles of Van Metre regions from ScienceBase
  #   requires running 0_config.R first
  # tar_target(p1_Reg_zip,
  #            {
  #              return("1_fetch/in/HydrologicRegions.zip")},
  #            format = "file"
  # ),
  # unzip file and point to region shapefile
  tar_target(p1_Reg_shp,
             sb_initialize_and_download_zipped(
               sb_id = "643706ffd34ee8d4addcc593",
               unzip_file_to_check = "1_fetch/in/HydrologicRegions/HydrologicRegions.shp",
               names = "HydrologicRegions.zip",
               destination_zip = "1_fetch/in/HydrologicRegions.zip",
               download_dir = "1_fetch/in/HydrologicRegions/",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  # Spatial data
  tar_target(
    p1_usgs_crs,
    "EPSG:5070"
  ),
  tar_target(
    p1_CONUS_mainstem_gdb,
    sb_initialize_and_download_zipped(
      sb_id = "60cb5edfd34e86b938a373f4",
      unzip_file_to_check = "1_fetch/in/WBD_National_GDB/WBD_National_GDB.gdb",
      names = "WBD_National_GDB.zip",
      destination_zip = "1_fetch/in/WBD_National_GDB.zip",
      download_dir = "1_fetch/in/WBD_National_GDB/",
      overwrite_fileL = FALSE),
    format = "file"
  ),
  tar_target(p1_mainstem_HUC8_raw_sf,
             prep_sf(gdb_file = p1_CONUS_mainstem_gdb,
                     layer = "WBDHU8",
                     crs_out = p1_usgs_crs,
                     exclude_non_plot_hucs = TRUE)
             ),
  tar_target(p1_mainstem_HUC12_raw_sf,
             prep_sf(gdb_file = p1_CONUS_mainstem_gdb,
                     layer = "WBDHU12",
                     crs_out = p1_usgs_crs,
                     exclude_non_plot_hucs = TRUE)
  ),
  
  # Crosswalk between HUC12, AggReg, and Reg
  tar_target(
    p1_CONUS_crosswalk,
    sb_initialize_and_download(
      sb_id = "643706ffd34ee8d4addcc593",
      names = "HUC12_VanMetre_crosswalk_230509.csv",
      destinations = "1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv",
      overwrite_fileL = FALSE
    ),
    format = "file"
  ),
  
  ##############################################
  # 
  #           WATER QUALITY DATA
  # 
  # TN = TOTAL NITROGEN (EXTRACTED FROM ELMERA'S SOFTWARE RELEASE)
  tar_map(
    values = tibble(nutrient = c("tn", "tp", "ss")),
    tar_target(p1_wq_Reg_csv,
               sprintf("1_fetch/in/p2_load_%s.csv", nutrient),
               format = "file"),
    tar_target(p1_wq_Reg_df,
               readr::read_csv(p1_wq_Reg_csv,
                               show_col_types = FALSE)),
    names = nutrient),
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  # PS = Public Supply water use data
  tar_target(p1_wu_ps_gw_csv, # Public supply withdrawal from groundwater
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_GW_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_GW_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_ps_sw_csv, # Public supply withdrawal from surface water
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_SW_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_SW_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_ps_tot_csv, # Public supply withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_Tot_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_Tot_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  
  # IR = Irrigation water use data
  tar_target(p1_wu_ir_gw_csv, # Irrigation withdrawal from groundwater
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_GW_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_GW_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_ir_sw_csv, # Irrigation withdrawal from surface water
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_SW_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_SW_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_ir_tot_csv, # Irrigation withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_Tot_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_Tot_2000_2020.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  
  # TE = thermoelectric water use data
  tar_target(p1_wu_te_gw_csv, # Irrigation withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "gw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/gw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_te_sw_csv, # Irrigation withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "sw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/sw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_te_tot_csv, # Irrigation withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "total_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/total_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  
  ##############################################
  # 
  #           WATER BALANCE DATA
  # 
  # WATER STRESS INDEX "SURFACE WATER SUPPLY AND USE INDEX" SUI
  tar_target(p1_sui_csv,
             sb_initialize_and_download(
               sb_id = "6622aa30d34e7eb9eb7f99b5",
               names = "water_budget_sui_ensemble.csv",
               destinations = "1_fetch/in/water_budget_sui_ensemble.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"),
  
  ##############################################
  # 
  #           EXTERNAL DATA SOURCES
  # 
  # Social Vulnerability Index by HUC12
  # https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html
  tar_target(p1_svi_csv,
             sb_initialize_and_download(
               sb_id = "643706ffd34ee8d4addcc593",
               names = "HUC12_SVI.csv",
               destinations = "1_fetch/in/HUC12_SVI.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"),
  
  # Population data from water availability team (Ted Stets)
  tar_target(p1_popn_csv,
             sb_initialize_and_download(
               sb_id = "6622aa30d34e7eb9eb7f99b5",
               names = "USpopHUC12Export.csv",
               destinations = "1_fetch/in/USpopHUC12Export.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"),
  # Crosswalk to convert from water service area (wsa_agidf) to HUC12
  tar_target(p1_wsa_crosswalk_csv,
             "1_fetch/in/huc12_disaggregation.csv")
)
