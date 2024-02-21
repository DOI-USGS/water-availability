source("0_config/src/sb_cache.R")

# Following DSP manual, instructions for using ScienceBase programatically, 
# as of 2/21/2024
initialize_and_cache_sb(
  sb_username = "username@usgs.gov", # Change to your ScienceBase login
  renviron_file = ".Renviron",
  override_login = FALSE
) 
