#' @title Prepare the shapefiles into sf for creating svgs/maps
#' @param in_shp The shapefile pathway that is used to build the sf
#' 
regions_to_sf <- function(in_shp){
  hr <- st_read(in_shp)
  
  # Simplify sfs and remove gaps (e.g., Columbia River)
  hr_simplified <- hr |> 
    # Simplify polyons
    rmapshaper::ms_simplify(keep = 0.01) |> 
    # Remove gaps
    sf::st_buffer(1800) |> 
    sf::st_difference() |>
    # Correct invalid topology incorrect geometry types
    sf::st_make_valid() |> 
    sf::st_cast("MULTIPOLYGON") |> 
    nngeo::st_remove_holes() |> 
    # Transform spatial projection
    st_transform(crs = "EPSG: 5070") |>
    dplyr::rename("Region" = "HR_Number")
    #select(-Region_nam, -AggRegion, -AggRegion_)
    
  return(hr_simplified)
  
}
