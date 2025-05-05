#' @description fetch water quality data
#' 
#' @param in_csv input pathway for raw data
#' @param in_COMID_xwalk crosswalk to align COMID and HUC12s
process_wq_HUC12 <- function(in_csv, in_COMID_xwalk){
  
  # read in COMID crosswalk
  # 
  xwalk <- data.table::fread(in_COMID_xwalk, keepLeadingZeros = TRUE) |>
    tidytable::select(HUC12 = huc12, comid = featureid, weights) |> 
    select(comid, HUC12, weights) #|>
    #group_by(comid) |> 
    #slice_max(weights)
  
  # filter sources to all sources
  out_all_sources <- in_csv |>
    filter(category == "All sources") |>
    select(comid, value, category, constituent) 
  
  # extract values of load by comid for each HUC12
  joined_loads <- xwalk |> left_join(out_all_sources, by = "comid") |>
    select(HUC12, value)
  
  # sum loads up by HUC12
  total_load_HUC12 <- joined_loads |>
    group_by(HUC12) |>
    summarize(total_load = sum(value, na.rm = TRUE))
  
  return(total_load_HUC12)
}

#' @description process HUC12 water quality data by HUC8
#' 
#' @param data_in data that was processed to HUC12
process_wq_HUC8 <- function(data_in){
  # sum loads up by HUC8
  data_out <- data_in |>
    mutate(HUC8 = substr(HUC12, 1, 8)) |>
    group_by(HUC8) |>
    summarize(total_load = sum(total_load, na.rm = TRUE))
  
  return(data_out)
}




#' @description Read in loads by nutrient from water quality pipeline
#' 
#' @param in_csv input pathway for raw data
#' @param nutrient nutrient name defined by tar_map()
process_wq_data <- function(in_csv, nutrient){
  
  # generalize and standardize categories for website
  out_cleaned <- in_csv |> 
    filter(category != "All sources") |>
    dplyr::rename(original_category = category) |>
    dplyr::mutate(category = dplyr::case_when(
      original_category %in% c("Forests", "Geologic sources", "Nitrogen fixation",
                               "Shrub lands", "Springs", "Stream channel") ~ "Natural sources",
      original_category %in% c("Fertilizer and manure", "Agricultural lands") ~ "Agriculture",
      original_category %in% c("Imports", "Mining", "Other land use", "Developed") ~ "Other Human Sources",
      original_category %in% c("Atmospheric deposition") ~ original_category,
      original_category %in% c("Wastewater") ~ original_category,
      TRUE ~ "ttt"
    )) |> 
    # rename column in updated p2_load data
    dplyr::rename(total_load = value)
  
  # Total load by region
  total_by_reg <- out_cleaned |>
    dplyr::group_by(region_nam) |>
    dplyr::summarize(sum_total = sum(total_load, na.rm = TRUE),
                     # also in 1000 Mg units
                     sum_1kMg = sum_total/1000000)
  
  # Total load by region, category
  out_mean <- out_cleaned |>
    dplyr::select(-original_category) |> #-percent, -sum_total, 
    dplyr::group_by(category, region_nam) |> 
    dplyr::summarize(total_load = sum(total_load, na.rm = TRUE),
                     # also in 1000 Mg units
                     load_1kMg = case_when(total_load == 0 ~ 0,
                                           total_load > 0 ~ total_load/1000000)) |>
    dplyr::ungroup() 
  
  # Add Atmospheric deposition = 0 for phosphorus, only have to add one region
  # because complete step will fill in for the rest of the regions
  if(nutrient == "tp") {
    out_mean <- out_mean |>
      bind_rows(tibble(
        category = "Atmospheric deposition",
        region_nam = "Florida",
        total_load = 0,
        load_1kMg = 0
      ))
  }
  
  # d3 errors if any category-region combination is missing (0 load for a category)
  # so going to add zeros in when that happens
  out_complete <- out_mean |>
    complete(category, region_nam, fill = list(total_load = 0,
                                               load_1kMg = 0))
  
  # Calculate percent load
  out_pct <- out_complete |>
    left_join(total_by_reg, by = "region_nam") |>
    mutate(percent_load = (total_load/sum_total)*100) |>
    mutate(nutrient = nutrient) 
  
  # Aggregated region names from raw data
  aggReg <- in_csv |> #out_raw |>
    group_by(aggregion_nam, region_nam) |>
    summarize()
  
  # final data with aggregated region names
  out <- out_pct |>
    left_join(aggReg, by = "region_nam") 
  
}
