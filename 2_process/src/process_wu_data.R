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

# Add Source (gw or sw) and Use (te, ps, or ir)0
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
mean_wu_HUC8 <- function(..., min_year, max_year) {
  data_in <- bind_rows(...)
  
  temp_use <- unique(data_in$use_type)
  
  data_in |>
    # Select only focal years
    filter(year >= min_year,
           year <= max_year) |>
    # Aggregate spatially to HUC8
    group_by(HUC8, source_type, use_type, year, month) |>
    summarise(wu_mgd = sum(wu_mgd, na.rm = TRUE)) |>
    # Aggregate temporally to get average water use in each year
    tidytable::mutate(
      days_per_month = lubridate::days_in_month(
        as_date(sprintf('%s/%s/01', year, month))),
      wu_mgm = wu_mgd * days_per_month) %>%
    tidytable::group_by(HUC8, source_type, use_type, year) |>
    tidytable::summarise(wu_mgy = sum(wu_mgm, na.rm = TRUE),
                         wu_mgd = sum(wu_mgm, na.rm = TRUE)/
                           sum(days_per_month, na.rm = TRUE))  |>
    # Get average water use across 20 years
    tidytable::group_by(HUC8, source_type, use_type) |>
    tidytable::summarise(mean_wu_mgd = mean(wu_mgd, na.rm = TRUE)) |>
    # Pivot to wide format
    pivot_wider(names_from = source_type, values_from = mean_wu_mgd) |>
    # calculate percent gw and sw
    mutate(gw_pct = gw/total,
           sw_pct = sw/total,
            use_name = use_type) |>
    rename_at(vars(-HUC8), ~ sprintf("%s_%s", temp_use, .))
}
