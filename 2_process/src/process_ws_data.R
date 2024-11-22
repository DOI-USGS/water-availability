compare_ws_mean <- function(data_in, supply_name, min_year, max_year, xwalk){
  
  # read in raw data from csv
  raw_data <- readr::read_csv(data_in,
                              show_col_types = FALSE) |>
    mutate(HUC8 = str_sub(HUC, 1, 8)) |>
    pivot_longer(cols = starts_with("20"), # select all columns that start with "20"
                 names_to = c("year", "month"), 
                 names_sep = "_", 
                 names_transform = list(year = as.integer, month = as.integer), 
                 values_to = "supply") |>
  rename(HUC12 = HUC) 
  
  # filter by water years
  years <- raw_data |> 
    mutate(water_year = case_when(month %in% 10:12 ~ year + 1,
                                  month < 10 ~ year)) |>
    filter(water_year >= min_year, 
           water_year <= max_year)
  
  # Join with crosswalk
  joined <- years |>
    left_join(xwalk, by = "HUC12") |>
    mutate(supply_category = supply_name)
  
  # Calculate weighted mean of the supply by area
  weighted_mean <- joined |>
    filter(!is.na(Area_sqkm)) |>
    group_by(Region_nam, AggRegion_nam, month, water_year, supply_category) |>
    summarise_at(
      "supply",
      ~ weighted.mean(x = .x, w = Area_sqkm, na.rm = TRUE)) 
  
  # Calculate deviation from mean by region
  deviation <- weighted_mean |>
    group_by(month, Region_nam, supply_category) |>
    mutate(norm_val = ((supply - mean(supply))/max(supply))*100) |>
    mutate(hi_lo = case_when(norm_val > 0 ~ 'Wetter than average',
                             .default = 'Drier than average'))
  
  
}