source("1_fetch/src/sb_login_token.R")

p1_targets <- list(
  # Download shapefiles of Van Metre regions from ScienceBase
  #   requires running 0_config.R first
  tar_target(p1_regions_zip,
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
  tar_target(p1_regions_shp,
             {unzip(zipfile = p1_regions_zip, 
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
    p1_mainstem_zip,
    {sb_initialize_and_download(sb_id = "60cb5edfd34e86b938a373f4",
                                names = "WBD_National_GDB.zip",
                                destinations = "1_fetch/in/WBD_National_GDB.zip",
                                overwrite_fileL = FALSE)
      return("1_fetch/in/WBD_National_GDB.zip")},
    format = "file"
  ),
  
  # Crosswalk
  
  tar_target(
    p1_vm_crosswalk,
    {sb_initialize_and_download(
      sb_id = "643706ffd34ee8d4addcc593",
      names = "HUC12_VanMetre_crosswalk_230509.csv",
      destinations = "1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv",
      overwrite_fileL = FALSE
    )
      return("1_fetch/out/HUC12_VanMetre_crosswalk_230509.csv")},
    format = "file"
  ),
  
  ###### water use data 
  # PS = Public Supply water use data
  tar_target(p1_ps_gw_csv, # Public supply withdrawal from groundwater
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_GW_2000_2020.csv",
               destinations = "1_fetch/in/water_use_data/PS_HUC12_GW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/water_use_data/PS_HUC12_GW_2000_2020.csv")},
             format = "file"
  ),
  tar_target(p1_ps_sw_csv, # Public supply withdrawal from surface water
             {sb_initialize_and_download(
               sb_id = "655e1bc9d34e3aa43a437141",
               names = "PS_HUC12_SW_2000_2020.csv",
               destinations = "1_fetch/in/water_use_data/PS_HUC12_SW_2000_2020.csv",
               overwrite_fileL = FALSE
             )
               return("1_fetch/in/water_use_data/PS_HUC12_SW_2000_2020.csv")},
             format = "file"
  )
  
)
