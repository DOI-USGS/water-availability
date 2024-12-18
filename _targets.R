library(targets)
library(tarchetypes)
library(tidyverse)
library(sf)

# Note: also requires installing (but not loading) "tidytable"
tar_option_set(packages = c(
  # global
  "tidyverse",
  "sf",
  # fetch
  "sbtools",
  "maps",
  # process
  "stringr",
  "lubridate",
  "rmapshaper",
  "nngeo",
  "prettyunits",
  "purrr",
  # visualize
  "gridSVG",
  "grid",
  "scico",
  "sysfonts",
  "showtext",
  "magick",
  "cowplot",
  "packcircles",
  "ggtern",
  "geojsonio",
  "tigris",
  "geofacet"))

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
#     # svi = social vulnerability index
#     # popn = population information from water use modeling team
#     # wsa = water service area (census areas related to per capita water use)

# Phase target makefiles
#   NEED to run 0_config.R first unless you've already fetched SB items
source("1_fetch.R")
source("2_process.R")
source("3_visualize.R")

# Combined list of target outputs
c(p1_targets, p2_targets, p3_targets)
