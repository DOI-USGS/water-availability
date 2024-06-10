mean_sui <- function(data_in, 
                     min_year, 
                     max_year,
                     HUC_level){
  
  
  raw <- data_in |>
    rename(HUC12 = huc) |>
    mutate(year = as.numeric(substr(year_month, 1, 4)),
           HUC8 = substr(HUC12, 1, 8)) |>
    # Select only focal years
    filter(year >= min_year,
           year <= max_year) 
  
  if(HUC_level == 12){
    raw_mean <- raw |>
      group_by(HUC12) |>
      summarize(sui_mean = mean(SUI, na.rm = TRUE))
  } else if(HUC_level == 8){
    raw_mean <- raw |>
      group_by(HUC8) |>
      summarize(sui_mean = mean(SUI, na.rm = TRUE))
  }
}

mean_sui_by_year <- function(data_in, 
                             HUC_level){
  
  
  raw <- data_in |>
    rename(HUC12 = huc) |>
    mutate(year = as.numeric(substr(year_month, 1, 4)),
           HUC8 = substr(HUC12, 1, 8)) 
  
  if(HUC_level == 12){
    raw_mean <- raw |>
      group_by(HUC12, year) |>
      summarize(sui_mean = mean(SUI, na.rm = TRUE))
  } else if(HUC_level == 8){
    raw_mean <- raw |>
      group_by(HUC8, year) |>
      summarize(sui_mean = mean(SUI, na.rm = TRUE))
  }
  
  raw_mean_wide <- raw_mean |>
    pivot_wider(names_from = year,
                names_prefix = "sui_",
                values_from = sui_mean)
}
