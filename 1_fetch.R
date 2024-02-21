source("1_fetch/src/sb_login_token.R")

p1_targets <- list(
  # Download shapefiles of Van Metre regions from ScienceBase
  #   requires running 0_config.R first
  tar_target(p1_regions_zip,
             sb_initialize_and_download(
               sb_id = "643706ffd34ee8d4addcc593",
               names = "HydrologicRegions.zip",
               destinations = "1_fetch/in/HydrologicRegions.zip"
             ),
             format = "file"
  ),
  # unzip file and point to region shapefile
  tar_target(p1_regions_shp,
             {unzip(zipfile = p1_regions_zip, 
                   overwrite = FALSE,
                   exdir = "1_fetch/in/HydrologicRegions/")
               return("1_fetch/in/HydrologicRegions/HydrologicRegions.shp")},
             format = "file"
  )
)