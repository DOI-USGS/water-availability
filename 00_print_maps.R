library(targets)
library(tidyverse)
library(sf)

tar_make(p3_map_stress_png)

tar_make(p3_wu_ir_HUC12_map_png)
tar_make(p3_wu_ps_HUC12_map_png)
tar_make(p3_wu_te_HUC12_fresh_map_png)
tar_make(p3_wu_te_HUC12_saline_map_png)

tar_load(p2_State_sf)
tar_load(p2_Reg_sf)

## current conditions
sept <- read_csv('3_visualize/in/flow_conditions_202409.csv')
oct <- read_csv('3_visualize/in/flow_conditions_202410.csv')

# make streamflow percentiles like river conditions
sept

sites <- unique(c(sept$site_no, oct$site_no))
sites

site_info <- dataRetrieval::readNWISsite(siteNumbers = sites) 
site_info

site_sf <- st_as_sf(site_info, coords = c('dec_long_va', 'dec_lat_va'), crs = 4236) |> 
  st_transform(st_crs(p2_State_sf))
site_sf

p2_State_sf

sept27 <- site_sf |> left_join(sept |> filter(dateTime == as.Date('2024-09-27'))) |> shift_geometry()
sept27

library(tigris)

states <- states(cb = TRUE)
shifted_states <- shift_geometry(states)

shifted_states |> ggplot() +
  geom_sf(color = 'black') +
  geom_sf(data= sept27, aes(color = per))

sept27 |>
  ggplot()+geom_histogram(aes(x=dec_long_va))
unique(sept27$)