source("1_fetch/src/sb_fetch_helpers.R")
source("1_fetch/src/wq_fetch_process.R")



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
  tar_target(p1_Reg_shp, # 64947132d34ef77fcb015320 - Boundaries.zip - HydrologicRegions.shp
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
    p1_CONUS_mainstem_gdb, # 63cb38b2d34e06fef14f40ad - same file
    sb_initialize_and_download_zipped(
      sb_id = "63cb38b2d34e06fef14f40ad",  #"60cb5edfd34e86b938a373f4",
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
    p1_CONUS_crosswalk,# 66833671d34e57e93663d8a5 - HUC12_HydroRegion_crosswalk.csv
    sb_initialize_and_download(
      sb_id = "66833671d34e57e93663d8a5", #"643706ffd34ee8d4addcc593",
      names = "HUC12_HydroRegion_crosswalk.csv", #"HUC12_VanMetre_crosswalk_230509.csv",
      destinations = "1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv",
      overwrite_fileL = FALSE
    ),
    format = "file"
  ),
  
  ##############################################
  # 
  #           WATER QUALITY DATA
  # 
  # EXTRACTED FROM ELMERA'S SOFTWARE RELEASE, loads by source
#  tar_map(
#    values = tibble(nutrient = c("tn", "tp", "ss")),
#    tar_target(p1_wq_Reg_csv,
#               sprintf("1_fetch/in/p2_load_%s.csv", nutrient),
#               format = "file"),
#    tar_target(p1_wq_Reg_df,
#               process_wq_data(in_csv = p1_wq_Reg_csv,
#                               nutrient = nutrient)),
#    tar_target(p1_wq_Reg_d3_csv,
#               readr::write_csv(p1_wq_Reg_df,
#                                file = sprintf("public/wq_sources_%s.csv", nutrient))),
#    names = nutrient),
  
  # EXTRACTED FROM ELMERA'S SOFTWARE RELEASE, threats by source
  tar_target(p1_wq_threats_csv,
             "1_fetch/in/WaterQuality_UsePercent_PlottingData.csv",
             format = "file"),
  
  # using original data release and processing steps
  # track relevant crosswalk files
  tar_target( # need to ask anthony about this one since it's a local download from the water quality figures repo
    p1_sparrow_variable_group_xwalk,
    "1_fetch/in/SPARROW_variableNames_grouped_inc.csv",
    format = "file"
  ),
  # Download COMID to HUC12 crosswalk
  tar_target(
    p1_comid_huc12_xwalk,
    sbtools::item_file_download(
      "66340d6ad34e9af276220a0a",
      names = "nhd_huc12_weights_r.csv",
      destinations = "1_fetch/out/nhd_huc12_weights_r.csv"
    ),
    format = "file"
  ),
  
  tar_target(
    p1_mw_names,
    c(
      "mw_cats.zip", "mw_sparrow_model_output_TN.txt",
      "mw_sparrow_model_output_TP.txt", "mw_sparrow_model_output_SS.txt",
      "mw_sparrow_model_output_FLOW.txt"
    )
  ),
  tar_target(
    p1_mw_files,
    item_file_download(
      sb_id = "5cbf5150e4b09b8c0b700df3",
      names = p1_mw_names,
      destinations = file.path("1_fetch", "out", p1_mw_names)
    ),
    format = "file"
  ),
  
  # Download Northeast files from ScienceBase
  tar_target(
    p1_ne_names,
    c(
      "ne_cats.zip", "ne_sparrow_model_output_tn.txt",
      "ne_sparrow_model_output_tp.txt", "ne_sparrow_model_output_ss.txt",
      "ne_sparrow_model_output_flow.txt"
    )
  ),
  tar_target(
    p1_ne_files,
    item_file_download(
      sb_id = "5d4192aee4b01d82ce8da477",
      names = p1_ne_names,
      destinations = file.path("1_fetch", "out", p1_ne_names)
    ),
    format = "file"
  ),
  
  # Download Pacific files from ScienceBase
  tar_target(
    p1_pac_names,
    c(
      "PAC_CATS.zip", "pac_sparrow_model_output_tn.txt",
      "pac_sparrow_model_output_tp.txt", "pac_sparrow_model_output_ss.txt",
      "pac_sparrow_model_output_wb.txt"
    )
  ),
  tar_target(
    p1_pac_files,
    item_file_download(
      sb_id = "5d407318e4b01d82ce8d9b3c",
      names = p1_pac_names,
      destinations = file.path("1_fetch", "out", p1_pac_names)
    ),
    format = "file"
  ),
  
  # Download Southeast files from ScienceBase
  tar_target(
    p1_se_names,
    c(
      "se_catchments.zip", "se_sparrow_model_output_TN.txt",
      "se_sparrow_model_output_TP.txt", "se_sparrow_model_output_Sed.txt",
      "se_sparrow_model_output_FLOW.txt"
    )
  ),
  tar_target(
    p1_se_files,
    item_file_download(
      sb_id = "5d6e70e5e4b0c4f70cf635a1",
      names = p1_se_names,
      destinations = file.path("1_fetch", "out", p1_se_names)
    ),
    format = "file"
  ),
  
  # Download Southwest files from ScienceBase
  tar_target(
    p1_sw_names,
    c(
      "sw_cats.zip", "sw_sparrow_model_output_TN.txt",
      "sw_sparrow_model_output_TP.txt", "sw_sparrow_model_output_SS.txt",
      "sw_sparrow_model_output_flow.txt"
    )
  ),
  tar_target(
    p1_sw_files,
    item_file_download(
      sb_id = "5f8f1f1282ce06b040efc90e",
      names = p1_sw_names,
      destinations = file.path("1_fetch", "out", p1_sw_names)
    ),
    format = "file"
  ),
  
  # reorganize ScienceBase files into spatial, tn, tp, tss
  tarchetypes::tar_map(
    values = tibble::tibble(
      suffix = c(
        "spatial_zip", "tn_data_txt", "tp_data_txt", "ss_data_txt",
        "flow_data_txt"
      ),
      extension_map = c(".zip", ".txt", ".txt", ".txt", ".txt"),
      pattern_map = c(NA, "_tn", "_tp", "_ss|_sed", "_flow|_wb")
    ),
    tar_target(
      p1_reg,
      subset_files(
        files = c(p1_mw_files, p1_ne_files, p1_pac_files, p1_se_files,
                  p1_sw_files),
        extension = extension_map,
        pattern = pattern_map
      ),
      format = "file"
    ),
    names = suffix
  ),
  
  tar_target(
    p1_reg_tibble,
    regional_tibble(
      regions = c("mw", "ne", "pac", "se", "sw"),
      spatial_files = p1_reg_spatial_zip,
      tn_files = p1_reg_tn_data_txt,
      tn_cols = c("al_tn", "tn", "al_tn", "al_tn", "al_tn"),
      tn_abbrev_cols = c("il_", "in", "il_", "il_", "il_"),
      tn_units = "kg/yr",
      tp_files = p1_reg_tp_data_txt,
      tp_cols = c("al_tp", "tp", "al_tp", "al_tp", "al_tp"),
      tp_abbrev_cols = c("il_", "ip", "il_", "il_", "il_"),
      tp_units = "kg/yr",
      ss_files = p1_reg_ss_data_txt,
      ss_cols = c("al_ss", "ts", "al_ss", "al_ss", "al_ss"),
      ss_abbrev_cols = c("il_", "is", "il_", "il_", "il_"),
      ss_units = c("MT/yr", "megagrams/yr", "kg/yr", "MT/year", "MT/year"),
      flow_files = p1_reg_flow_data_txt,
      flow_cols = c("al_q", "tq", "al_q", "al_q", "al_q"),
      flow_units = "cfs"
    )
  ),
  # TP processing to calculate loads from sources
  tarchetypes::tar_map( 
    values = tibble::tibble(nutrient = c("tn", "tp", "ss")),
    tar_target(
      p2_load,
      process_loads(
        in_tibble = p1_reg_tibble,
        nutrient = nutrient,
        var_dic_csv = p1_sparrow_variable_group_xwalk,
        crosswalk = p1_comid_huc12_xwalk,
        # this is using the updated version Anthony gave us but the original water 
        # quality figures used the version from sb id 643706ffd34ee8d4addcc593
        vm_crosswalk = p1_CONUS_crosswalk
      )
    ),
    tar_target(p1_wq_Reg_df,
               process_wq_data(in_csv = p2_load,
                               nutrient = nutrient)),
    tar_target(p1_wq_Reg_d3_csv,
               readr::write_csv(p1_wq_Reg_df,
                                file = sprintf("public/wq_sources_%s.csv", nutrient))),
    names = nutrient
  ),
  
  
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
  tar_target(p1_wu_te_gw_csv, # thermoelectric withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "gw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/gw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_te_sw_csv, # thermoelectric withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "sw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/sw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_te_tot_csv, # thermoelectric fresh withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "total_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/total_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  tar_target(p1_wu_te_tot_saline_csv, # thermoelectric saline withdrawal (total)
             sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "sw_saline_wd_mgd.csv",
               destinations = "1_fetch/in/sw_saline_wd_mgd.csv",
               overwrite_fileL = FALSE
             ),
             format = "file"
  ),
  
  ##############################################
  # 
  #           WATER BALANCE DATA
  # 
  # WATER STRESS INDEX "SURFACE WATER SUPPLY AND USE INDEX" SUI
  tar_target(p1_sui_csv, # 6685ad6bd34e10615ec29864 - same file (in review data release)
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
