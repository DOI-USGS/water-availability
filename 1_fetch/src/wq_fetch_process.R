process_wq_data <- function(in_csv, nutrient){
  
  # read csv
  out_raw <- readr::read_csv(in_csv,
                  show_col_types = FALSE) 
  
  # generalize and standardize categories for website
  out_cleaned <- out_raw |>
    dplyr::rename(original_category = category) |>
    dplyr::mutate(category = dplyr::case_when(
      original_category %in% c("Forests", "Geologic sources", "Nitrogen fixation",
                               "Shrub lands", "Springs", "Stream channel") ~ "Natural sources",
      original_category %in% c("Fertilizer and manure", "Agricultural lands") ~ "Agriculture",
      original_category %in% c("Imports", "Mining", "Other land use", "Developed") ~ "Other Human Sources",
      original_category %in% c("Atmospheric deposition") ~ original_category,
      original_category %in% c("Wastewater") ~ original_category,
      TRUE ~ "ttt"
    )) 
  
  # Total load by region
  total_by_reg <- out_cleaned |>
    dplyr::group_by(region_nam) |>
    dplyr::summarize(sum_total = sum(total_load, na.rm = TRUE),
                     # also in 1000 Mg units
                     sum_1kMg = sum_total/1000000)
  
  # Total load by region, category
  out_mean <- out_cleaned |>
    dplyr::select(-percent, -sum_total, -original_category) |>
    dplyr::group_by(category, region_nam) |> 
    dplyr::summarize(total_load = sum(total_load, na.rm = TRUE),
                     # also in 1000 Mg units
                     load_1kMg = total_load/1000000) |>
    ungroup()
  
  
  # d3 errors if any category-region combination is missing (0 load for a category)
  # so going to add zeros in when that happens
  out_complete <- out_mean |>
    complete(category, region_nam, fill = list(total_load = 0))
  
  # Calculate percent load
  out_pct <- out_complete |>
    left_join(total_by_reg, by = "region_nam") |>
    mutate(percent_load = (total_load/sum_total)*100) |>
    mutate(nutrient = nutrient) 
  
  # Aggregated region names from raw data
  aggReg <- out_raw |>
    group_by(aggregion_nam, region_nam) |>
    summarize()
  
  # final data with aggregated region names
  out <- out_pct |>
    left_join(aggReg, by = "region_nam") 
  
}
