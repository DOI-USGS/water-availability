#' @description Get water use data ready for dumbbell plots
#' 
#' @param raw_gw_in target of raw groundwater data
#' @param raw_sw_in target of raw surfacewater data 
#' @param water_year water year for analysis/plotting
prep_for_dumbbell <- function(raw_gw_in, raw_sw_in, water_year){
  
  # List of the column headers in format YYYY_MM for *water year*
  water_year_table <- tibble(
    month_num = c(10:12, sprintf("0%s", 1:9)),
    year_num = c(rep(water_year - 1, 2), rep(water_year, 10)),
    column_name = sprintf("%s_%s", year_num, month_num),
    days_per_month = lubridate::days_in_month(as.Date(sprintf("%s-%s-01", year_num, month_num)))
  )
  
  # select water year
  gw_out <- raw_gw_in |>
    select(HUC, Region_nam, AggRegion_nam, 
           all_of(as.character(water_year_table$column_name)),
           use) 
  sw_out <- raw_sw_in |>
    select(HUC, Region_nam, AggRegion_nam, 
           all_of(as.character(water_year_table$column_name)),
           use) 
  
  # First, multiply each month's value by the number of days in that month
  # to get to millions of gallons per month
  gw_mgm <- gw_out |> 
    select(-HUC, -Region_nam, -AggRegion_nam, -use) |>
    rowwise() |>
    mutate(across(all_of(as.character(water_year_table$column_name))) * 
             water_year_table$days_per_month) 
  sw_mgm <- sw_out |> 
    select(-HUC, -Region_nam, -AggRegion_nam, -use) |>
    rowwise() |>
    mutate(across(all_of(as.character(water_year_table$column_name))) * 
             water_year_table$days_per_month)
  
  # append "mgm" to names
  names(gw_mgm) <- sprintf("mgm_%s", names(gw_mgm))
  names(sw_mgm) <- sprintf("mgm_%s", names(sw_mgm))
  
  # Left join to original data
  gw_join <- bind_cols(gw_out, gw_mgm)
  sw_join <- bind_cols(sw_out, sw_mgm)
  
  # Then add up over the year to get million of gallons per year and
  # divide by # of days/year to get back to average million gallons per day
  gw_huc12_mgd <- gw_join |>
    rowwise() |>
    mutate(mgy = sum(c_across(as.character(sprintf("mgm_%s", water_year_table$column_name))), na.rm = TRUE),
           mgd = mgy/sum(water_year_table$days_per_month),
           water_year = water_year) |>
    rename(HUC12 = HUC)
  sw_huc12_mgd <- sw_join |>
    rowwise() |>
    mutate(mgy = sum(c_across(as.character(sprintf("mgm_%s", water_year_table$column_name))), na.rm = TRUE),
           mgd = mgy/sum(water_year_table$days_per_month),
           water_year = water_year) |>
    rename(HUC12 = HUC)
  
  # summarize by HUC8
  gw_huc8 <- gw_huc12_mgd |>
    mutate(HUC8 = substr(HUC12, start = 1, stop = 8)) |>
    group_by(HUC8, water_year) |>
    summarise(gw_total_wu = sum(mgd, na.rm = TRUE)) |> 
    ungroup() |>
    select(HUC8, gw_total_wu, water_year)
  sw_huc8 <- sw_huc12_mgd |>
    mutate(HUC8 = substr(HUC12, start = 1, stop = 8)) |>
    group_by(HUC8) |>
    summarise(sw_total_wu = sum(mgd, na.rm = TRUE)) |> 
    ungroup()|>
    select(HUC8, sw_total_wu)
  
  # join together
  ps_join <- gw_huc8 |>
    left_join(sw_huc8, by = "HUC8") |>
    rowwise() |>
    mutate(ps_total_wu = sum(gw_total_wu, sw_total_wu, na.rm = TRUE))
  
  
  return(ps_join)
}
