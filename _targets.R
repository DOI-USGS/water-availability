library(targets)

tar_option_set(packages = c("sbtools",
                            "tidyverse",
                            "sf",
                            "rmapshaper",
                            "nngeo",
                            "stringr",
                            "gridSVG"))

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

# Phase target makefiles
#   NEED to run 0_config.R first unless you've already fetched SB items
source("1_fetch.R")
source("2_process.R")
source("3_visualize.R")

# Combined list of target outputs
c(p1_targets, p2_targets, p3_targets)
