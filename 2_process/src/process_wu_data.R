# Pivot water use data from wide format (year-mo columns)
# to long format
data_pivot_long <- function(data) {
  data %>%
    pivot_longer(cols = starts_with('20'), 
                 names_to = c('year', 'month'), 
                 names_sep = '_', 
                 names_transform = list(year = as.integer, month = as.integer), 
                 values_to = 'wu_mgd')
}

# Add Source (gw or sw) and Use (te, ps, or ir)
data_add_source_use_type <- function(data, use_type, source_type) {
  data %>%
    mutate(use_type = use_type, source_type = source_type)
}

#################
# LOAD
#
# Load data and use the functions above for processing
load_wu_data <- function(data_path, use_type, source_type) {
  readr::read_csv(data_path,
                  show_col_types = FALSE) %>%
    mutate(HUC8 = str_sub(HUC, 1, 8)) %>%
    data_pivot_long() %>%
    data_add_source_use_type(use_type = use_type, source_type = source_type)
}

########################
#
#    AVERAGE WU OVER YEARS
#
mean_wu_HUC12 <- function(..., min_year, max_year) {
  data_in <- bind_rows(...) |>
    rename(HUC12 = HUC)
  
  temp_use <- unique(data_in$use_type)
  
  temp_source <- unique(data_in$source_type)
  

  data_out <- data_in |>
      # Select only focal years
      filter(year >= min_year,
             year <= max_year) |>
      # Aggregate spatially to HUC8
      group_by(HUC12, source_type, use_type, year, month) |>
      summarise(wu_mgd = sum(wu_mgd, na.rm = TRUE)) |>
      # Aggregate temporally to get average water use in each year
      tidytable::mutate(
        days_per_month = lubridate::days_in_month(
          as_date(sprintf('%s/%s/01', year, month))),
        wu_mgm = wu_mgd * days_per_month) %>%
      tidytable::group_by(HUC12, source_type, use_type, year) |>
      tidytable::summarise(wu_mgy = sum(wu_mgm, na.rm = TRUE),
                           wu_mgd = sum(wu_mgm, na.rm = TRUE)/
                             sum(days_per_month, na.rm = TRUE))  |>
      # Get average water use across 20 years
      tidytable::group_by(HUC12, source_type, use_type) |>
      tidytable::summarise(mean_wu_mgd = mean(wu_mgd, na.rm = TRUE)) |>
      # Pivot to wide format
      pivot_wider(names_from = source_type, values_from = mean_wu_mgd) 
  
  if(temp_source[1] == "saline") {
    data_final <- data_out |>
      # different than non-saline
      rename_with(~ sprintf("%s_%s", temp_use, .), .cols = !HUC12)
  } else {
    data_final <- data_out |>
      # Make sure that sw and gw are NOT NA if total != NA
      mutate(sw = case_when(!is.na(total) & is.na(sw) ~ 0,
                            TRUE ~ sw),
             gw = case_when(!is.na(total) & is.na(gw) ~ 0,
                            TRUE ~ gw)) |>
      # calculate percent gw and sw
      mutate(gw_pct = gw/total,
             sw_pct = sw/total,
             use_name = use_type) |>
      rename_with(~ sprintf("%s_%s", temp_use, .), .cols = !HUC12)
      
  }
  
  return(data_final)

}


##############################################################################
#
#       total water use by year
#
total_wu_yearly <- function(...,
                            min_year,
                            max_year){
  # combine three water use types
  data_in <- bind_rows(...)
  
  
  # filter by water years
  years <- data_in |> 
    mutate(water_year = case_when(month %in% 10:12 ~ year + 1,
                                  month < 10 ~ year)) |>
    filter(water_year >= min_year, 
           water_year <= max_year)
  
  # calculate days per month
  days_per_water_year <- tibble(
    water_year = rep(2010:2020, each = 12),
    month = rep(c(10:12,1:9), 11)
  ) |>
    mutate(day_count = lubridate::days_in_month(as.Date(sprintf("%s-%s-01", water_year, month)))) |>
    group_by(water_year) |>
    summarize(total_days_per_year = sum(day_count))
    
  # from mgd to mgm (monthly) by huc
  monthly_mgm <- years |>
    mutate(days_per_month = lubridate::days_in_month(as.Date(sprintf("%s-%s-01", water_year, month))),
           mgm = wu_mgd * days_per_month) 
  
  # calculate total mgd by year and source/use
  yearly_mgy_huc12 <- monthly_mgm |>
    group_by(use_type, source_type, water_year, HUC) |>
    summarize(mgy = sum(mgm, na.rm = TRUE))
  
  # add up across hucs
  yearly_mgy <- yearly_mgy_huc12 |>
    group_by(use_type, source_type, water_year) |>
    summarize(total_wu_mgy = sum(mgy, na.rm = TRUE)) 
  
  # Divide by days per year to get mgd by year
  yearly_mgd <- yearly_mgy |>
    left_join(days_per_water_year, by = "water_year") |>
    mutate(mgd = total_wu_mgy/total_days_per_year) |>
    # prep for d3
    mutate(Use = case_when(use_type == "ps" ~ "Public Supply",
                           use_type == "ir" ~ "Irrigation", 
                           source_type == "saline" ~ "Thermoelectric (saline)",
                           TRUE ~ "Thermoelectric (fresh)"))
  
  return(yearly_mgd)
  
}

#################################
## plotting ternary plot
##
# Set up non-spatial data for merging with spatial (total water use, ternary plot, etc)
total_wu_proportions <- function(ps_in, ir_in, te_in, 
                                 color_scheme){
  
  raw <- ps_in |> left_join(ir_in, by = "HUC12") |> left_join(te_in, by = "HUC12")

  summary <- raw |>
    rowwise() |>
    mutate(total_wu = sum(ps_total, ir_total, te_total, na.rm = TRUE)) |>
    # make NAs into zeros
    mutate(ps_total = case_when(is.na(ps_total) ~ 0,
                                TRUE ~ ps_total),
           ir_total = case_when(is.na(ir_total) ~ 0,
                                TRUE ~ ir_total),
           te_total = case_when(is.na(te_total) ~ 0,
                                TRUE ~ te_total)) |>
    # determine proportion
    mutate(ps_prop = case_when(ps_total == 0 ~ 0,
                               TRUE ~ ps_total / total_wu),
           ir_prop = case_when(ir_total == 0 ~ 0,
                               TRUE ~ ir_total / total_wu),
           te_prop = case_when(te_total == 0 ~ 0,
                               TRUE ~ te_total / total_wu)) 
  
  return(summary)
}
