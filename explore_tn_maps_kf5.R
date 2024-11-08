library(tidyverse)
library(targets)
library(sf)
library(purrr)
library(scico)

tar_load(p1_wq_Reg_df_tn)
tar_load(p1_wq_Reg_df_tp)
tar_load(p1_Reg_shp)
tar_load(p1_usgs_crs)

p2_AggReg_sf <- st_read(p1_Reg_shp) |> 
  st_transform(crs = p1_usgs_crs) |> 
  rename(region_nam = Name) |> 
  mutate(
    region_nam = dplyr::case_match(
      region_nam,
      "Souris-Red_Rainy" ~ "Souris-Red-Rainy",
      "Gulf Cost" ~ "Gulf Coast",
      "Tennesse-Missouri" ~ "Tennessee-Missouri",
      "Pacific NW" ~ "Pacific Northwest",
      .default = region_nam
    )
  )

p1_wq_Reg_tn_sf <- p1_wq_Reg_df_tn |> 
  left_join(p2_AggReg_sf, "region_nam") |> 
  st_as_sf()

list_of_sfs <- split(p1_wq_Reg_tn_sf, p1_wq_Reg_tn_sf$region_nam) |> 
  map(~ .x)

create_and_save_facet_map <- function(data, region_name) {
  plot <- ggplot(data) +
    geom_sf(data = p2_AggReg_sf, fill = NA, color = "black", size = 0.2) +
    geom_sf(aes(fill = total_load)) +  
    scale_fill_scico(palette = "batlow") + 
    facet_wrap(~ category) +          
    labs(fill = "Total Load") +
    theme_void() +
    theme(legend.position = "none")
  
  ggsave(filename = paste0("3_visualize/out/map_tn_tot_", gsub(" ", "_", region_name), ".png"),
         plot = plot, width = 10, height = 8, dpi = 300, bg = "white")
}

imap(list_of_sfs, ~ create_and_save_facet_map(.x, .y))