source("2_process/src/process_region_shp.R")

p2_targets <- list(
  # Master tibbles for cross-referencing region names, numbers
  tar_target(p2_region_name_xwalk,
             tibble(
               Region = 1:18,
               Region_nam = c("Northeast", "Atlantic Coast", "Florida", 
                            "Great Lakes", "Midwest", "Tennessee-Missouri",  
                            "Mississippi Embayment", "Gulf Coast",   
                            "Souris-Red-Rainy", "Northern High Plains",
                            "Central High Plains", "Southern High Plains",
                            "Texas", "Columbia-Snake",
                            "Central Rockies", "Southwest Desert",
                            "Pacific Northwest", "California-Nevada"),
               Region_nam_nospace = stringr::str_replace_all(Region_nam, pattern = " ", replacement = "_"),
               AggRegion = as.factor(c(2, 3, 3, 2, 2, 3, 3, 3, 2, 1, 1, 1, 3, 4, 4, 4, 4, 4)),
               AggReg_nam = c("Northeast through Midwest", "Southeast", "Southeast",
                              "Northeast through Midwest", "Northeast through Midwest",
                              "Southeast", "Southeast", "Southeast", 
                              "Northeast through Midwest", "High Plains", 
                              "High Plains", "High Plains", "Western", "Western",
                              "Western", "Western", "Western", "Western"),
               AggReg_nam_nospace = stringr::str_replace_all(AggReg_nam, pattern = " ", replacement = "_")
                              )
             ),
  
  # Create regions sf, simplified
  tar_target(p2_Region_sf,
             regions_to_sf(in_shp = p1_regions_shp) |>
               left_join(p2_region_name_xwalk, by = "Region")),
  tar_target(p2_AggRegion_sf,
             p2_Region_sf |> group_by(AggReg_nam) |> summarize() |>
               left_join(p2_region_name_xwalk, by = "AggReg_nam"))
)