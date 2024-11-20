source("1_fetch/src/sb_fetch_helpers.R")
source("1_fetch/src/wq_fetch_process.R")



p1_targets <- list(
  ##############################################
  # 
  #          SPATIAL DATA
  # 
  # unzip file and point to region shapefile
  tar_target(p1_Reg_shp, 
             sb_initialize_and_download_zipped(
               sb_id = "64947132d34ef77fcb015320",  #"643706ffd34ee8d4addcc593",
               #for some reason it's downloading within the boundaries directory (so nested boundaries folders)
               unzip_file_to_check = "1_fetch/in/Boundaries/Boundaries/HydrologicRegions.shp", 
               names = "Boundaries.zip",
               destination_zip = "1_fetch/in/Boundaries.zip",
               download_dir = "1_fetch/in/Boundaries/",
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
      sb_id = "63cb38b2d34e06fef14f40ad",  
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
  # State boundaries
  tar_target(
    p1_states_sf,
    st_as_sf(maps::map("state", fill = TRUE, plot = FALSE)) |> 
      filter(! ID %in% c("alaska", "hawaii")) |> 
      st_transform(p1_usgs_crs) |> 
      st_sf()
  ),
  
  # Crosswalk between HUC12, AggReg, and Reg
  tar_target(
    p1_CONUS_crosswalk,
    sb_initialize_and_download(
      sb_id = "66833671d34e57e93663d8a5", 
      names = "HUC12_HydroRegion_crosswalk.csv", 
      destinations = "1_fetch/out/HUC12_HydroRegion_crosswalk.csv",
      overwrite_fileL = FALSE
    ),
    format = "file"
  ),
  
  
  
  
  
  ##############################################
  # 
  #           WATER SUPPLY DATA
  # 
  # EXTRACTED FROM TO-BE-RELEASED PIPELINES, WATER SUPPLY AND UNCERTAINTY ANALYSIS
  #   To run this pipeline, must download temporary files from IWAAs sharepoint and 
  #     put them in the 1_fetch/in folder
  tar_target(p1_ws_precip_csv,
             "1_fetch/in/c404bc_rain_mm.csv",
             format = "file"),
  tar_target(p1_ws_et_csv,
             "1_fetch/in/model_ensemble_Evapotranspiration.csv",
             format = "file"),
  tar_target(p1_ws_sm_csv,
             "1_fetch/in/model_ensemble_huc12_Soil moisture percentage.csv",
             format = "file"),
  tar_target(p1_ws_sf_csv,
             "1_fetch/in/model_ensemble_huc12_Surface runoff.csv",
             format = "file"),
  
  
  
  ##############################################
  # 
  #           WATER QUALITY DATA
  # 
  # EXTRACTED FROM ELMERA'S SOFTWARE RELEASE, loads by source
  # need to run the initial-upload branch of the repo locally in the main file directory
  #     run with `targets::tar_make(starts_with("p2_load"))`
  # https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/iwaas-sparrow-figures/-/blob/initial-upload/01_fetch.R?ref_type=heads
  
  # TP processing to calculate loads from sources
  tarchetypes::tar_map( 
    values = tibble::tibble(nutrient = c("tn", "tp", "ss")),
    tar_target( # need to find a way to download p2_load target output from iwaas-sparrow-figures pipeline
      # current idea: read in _targets p2_load objects?
      p2_load,
      readRDS(sprintf("../iwaas-sparrow-figures/_targets/objects/p2_load_%s", nutrient))
    ),
    tar_target(p1_wq_Reg_df,
               process_wq_data(in_csv = p2_load,
                               nutrient = nutrient)),
    tar_target(p1_wq_Reg_d3_csv,
               readr::write_csv(p1_wq_Reg_df,
                                file = sprintf("public/wq_sources_%s.csv", nutrient))),
    names = nutrient),
  
  # EXTRACTED FROM ELMERA'S SOFTWARE RELEASE, threats by source
  tar_target(p1_wq_threats_csv,
             "1_fetch/in/WaterQuality_UsePercent_PlottingData.csv",
             format = "file"),
  
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  # PS = Public Supply water use data
  tar_target(p1_wu_ps_gw_csv, # Public supply withdrawal from groundwater
             "../water-use-huc12-crosswalk/02_process/out/final/PS_HUC12_GW_2000_2020.csv",
             format = "file"
  ),
  tar_target(p1_wu_ps_sw_csv, # Public supply withdrawal from surface water
             "../water-use-huc12-crosswalk/02_process/out/final/PS_HUC12_SW_2000_2020.csv",
             format = "file"
  ),
  tar_target(p1_wu_ps_tot_csv, # Public supply withdrawal (total)
             "../water-use-huc12-crosswalk/02_process/out/final/PS_HUC12_Tot_2000_2020.csv",
             format = "file"
  ),
  
  # IR = Irrigation water use data
  tar_target(p1_wu_ir_gw_csv, # Irrigation withdrawal from groundwater
             "../water-use-huc12-crosswalk/02_process/out/final/IR_HUC12_GW_WD_monthly_2000_2020.csv",
             format = "file"
  ),
  tar_target(p1_wu_ir_sw_csv, # Irrigation withdrawal from surface water
             "../water-use-huc12-crosswalk/02_process/out/final/IR_HUC12_SW_WD_monthly_2000_2020.csv",
             format = "file"
  ),
  tar_target(p1_wu_ir_tot_csv, # Irrigation withdrawal (total)
             "../water-use-huc12-crosswalk/02_process/out/final/IR_HUC12_Tot_WD_monthly_2000_2020.csv",
             format = "file"
  ),
  
  # TE = thermoelectric water use data
  tar_target(p1_wu_te_gw_csv, # thermoelectric ground water fresh withdrawal 
             "../water-use-huc12-crosswalk/02_process/out/final/gw_fresh_wd_mgd.csv",
             format = "file"
  ),
  tar_target(p1_wu_te_sw_csv, # thermoelectric surface water fresh withdrawal 
             "../water-use-huc12-crosswalk/02_process/out/final/sw_fresh_wd_mgd.csv",
             format = "file"
  ),
  tar_target(p1_wu_te_tot_csv, # thermoelectric fresh withdrawal (total)
             "../water-use-huc12-crosswalk/02_process/out/final/total_fresh_wd_mgd.csv",
             format = "file"
  ),
  tar_target(p1_wu_te_tot_saline_csv, # thermoelectric saline withdrawal (total)
             "../water-use-huc12-crosswalk/02_process/out/final/sw_saline_wd_mgd.csv",
             format = "file"
  ),
  
  ##############################################
  # 
  #           WATER BALANCE DATA
  # 
  # WATER STRESS INDEX "SURFACE WATER SUPPLY AND USE INDEX" SUI
  tar_target(p1_sui_csv, 
             sb_initialize_and_download(
               sb_id ="6685ad6bd34e10615ec29864",  #"6622aa30d34e7eb9eb7f99b5",
               names = "water_budget_sui_ensemble.csv",
               destinations = "1_fetch/in/water_budget_sui_ensemble.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"),
  # WATER Supply and demand for each region from Ted
  tar_target(p1_supply_v_demand_csv,
             "1_fetch/in/regionSupplyandDemand.csv",
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
