source("1_fetch/src/sb_login_token.R")


### Naming conventions:
# Water Supply = ws
#     # precip = precipitation
#     # sf = streamflow / runoff
#     # swe = snow water equivalent
#     # sm = soil moisture
#     # et = evapotranspiration
# Water Use = wu
#     # ir = irrigation
#     # ps = public supply
#     # te = thermoelectric
#         # gw = groundwater
#         # sw = surface water
# Water Quality = wq
#     # ss = suspended solids
#     # tn = total nitrogen
#     # tp = total phosphorus
# Water Availability = wa
#     # sui = water stress/ surface water use imbalance
#     # 
# Global data sets 
#     # CONUS = conus
#     # AggReg = Aggregated regions
#     # Reg = hydrologic regions
#     # sv = social vulnerability


p1_targets <- list(
  ##############################################
  # 
  #          SPATIAL DATA
  # 
  # Download shapefiles of Van Metre regions from ScienceBase
  #   requires running 0_config.R first
  tar_target(p1_Reg_zip,
             {sb_initialize_and_download(
               sb_id = "643706ffd34ee8d4addcc593",
               names = "HydrologicRegions.zip",
               destinations = "1_fetch/in/HydrologicRegions.zip",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/HydrologicRegions.zip")},
             format = "file"
  ),
  # unzip file and point to region shapefile
  tar_target(p1_Reg_shp,
             {unzip(zipfile = p1_Reg_zip, 
                    overwrite = FALSE,
                    exdir = "1_fetch/in/HydrologicRegions/")
               return("1_fetch/in/HydrologicRegions/HydrologicRegions.shp")},
             format = "file"
  ),
  # Spatial data
  tar_target(
    p1_usgs_crs,
    "EPSG:5070"
  ),
  tar_target(
    p1_CONUS_mainstem_zip,
    {sb_initialize_and_download(sb_id = "60cb5edfd34e86b938a373f4",
                                names = "WBD_National_GDB.zip",
                                destinations = "1_fetch/in/WBD_National_GDB.zip",
                                overwrite_fileL = FALSE)
      return("1_fetch/in/WBD_National_GDB.zip")},
    format = "file"
  ),
  
  # Crosswalk
  
  tar_target(
    p1_CONUS_crosswalk,
    {sb_initialize_and_download(
      sb_id = "643706ffd34ee8d4addcc593",
      names = "HUC12_VanMetre_crosswalk_230509.csv",
      destinations = "1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv",
      overwrite_fileL = FALSE
    )
      return("1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv")},
    format = "file"
  ),
  
  ##############################################
  # 
  #           WATER USE DATA
  # 
  # PS = Public Supply water use data
  tar_target(p1_wu_ps_gw_csv, # Public supply withdrawal from groundwater
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_GW_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_GW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/PS_HUC12_GW_2000_2020.csv")},
             format = "file"
  ),
  tar_target(p1_wu_ps_sw_csv, # Public supply withdrawal from surface water
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_SW_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_SW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/PS_HUC12_SW_2000_2020.csv")},
             format = "file"
  ),
  tar_target(p1_wu_ps_tot_csv, # Public supply withdrawal (total)
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_Tot_2000_2020.csv",
               destinations = "1_fetch/in/PS_HUC12_Tot_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/PS_HUC12_Tot_2000_2020.csv")},
             format = "file"
  ),
  
  # IR = Irrigation water use data
  tar_target(p1_wu_ir_gw_csv, # Irrigation withdrawal from groundwater
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_GW_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_GW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/IR_HUC12_GW_2000_2020.csv")},
             format = "file"
  ),
  tar_target(p1_wu_ir_sw_csv, # Irrigation withdrawal from surface water
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_SW_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_SW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/IR_HUC12_SW_2000_2020.csv")},
             format = "file"
  ),
  tar_target(p1_wu_ir_tot_csv, # Irrigation withdrawal (total)
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "IR_HUC12_Tot_2000_2020.csv",
               destinations = "1_fetch/in/IR_HUC12_Tot_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/IR_HUC12_Tot_2000_2020.csv")},
             format = "file"
  ),
  
  # TE = thermoelectric water use data
  tar_target(p1_wu_te_gw_csv, # Irrigation withdrawal (total)
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "gw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/gw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/gw_fresh_wd_mgd.csv")},
             format = "file"
  ),
  tar_target(p1_wu_te_sw_csv, # Irrigation withdrawal (total)
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "sw_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/sw_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/sw_fresh_wd_mgd.csv")},
             format = "file"
  ),
  tar_target(p1_wu_te_tot_csv, # Irrigation withdrawal (total)
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "total_fresh_wd_mgd.csv",
               destinations = "1_fetch/in/total_fresh_wd_mgd.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/total_fresh_wd_mgd.csv")},
             format = "file"
  )
  
)
