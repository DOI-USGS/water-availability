# Load in packages
library(tidyverse)
library(targets)
library(sf)
library(purrr)
library(scico)

# Load in spatial data 
tar_load(p2_mainstem_HUC12_simple_sf)
p2_mainstem_HUC12_simple_sf <- janitor::clean_names(p2_mainstem_HUC12_simple_sf) |> select(huc12, geometry)
# nrow(p2_mainstem_HUC12_simple_sf) 83051

# Load in nutrient loads 
# These RDS were taken from water-quality-figures IWAAs pipeline
tn_loads <- readRDS("public/tn_loads.RDS") |>
  select(comid, value, category, constituent) |> 
  filter(category == "All sources")
# nrow(tn_loads) 1675944

# tp_loads <- readRDS("public/tp_loads.RDS") |> 
#   select(comid, value, category, constituent) |> 
#   filter(category == "All sources")
# 
# ss_loads <- readRDS("public/ss_loads.RDS") |>
#   select(comid, value, category, constituent) |> 
#   filter(category == "All sources")

# Load in comid -> huc12 xwalk 
# Only retain highest weighted huc12s
comid_huc12_xwalk <- data.table::fread("public/nhd_huc12_weights_r.csv", keepLeadingZeros = TRUE) |>
  tidytable::select(huc12, comid = featureid, weights) |> 
  group_by(huc12) |> 
  slice_max(weights)
# nrow(comid_huc12_xwalk) 85685

# Join spatial data to xwalk and nutrient load by comid
tn_loads_huc12<- p2_mainstem_HUC12_simple_sf |> 
  left_join(comid_huc12_xwalk, by = "huc12") |> 
  left_join(tn_loads, by = "comid") 
# nrow(tn_loads_huc12) 83052
# sum(is.na(tn_loads_huc12$value)) 35195

# Map just nitrogen loads
map <- ggplot(tn_loads_huc12) +
  geom_sf(aes(fill = value),
          color = NA, size = 0)  +
  scale_fill_scico(palette = "batlow") +
  theme_void() 
# +
#   theme(legend.position = "none")

# Save 
ggsave(plot = map,
       filename = "3_visualize/out/tn_loads_huc12.png", device = "png", bg = "transparent",
       dpi = 300, units = "in", width = 6, height = 9)