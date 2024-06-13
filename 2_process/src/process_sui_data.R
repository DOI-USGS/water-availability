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
      summarize(mean_sui = mean(SUI, na.rm = TRUE))
  } else if(HUC_level == 8){
    raw_mean <- raw |>
      group_by(HUC8) |>
      summarize(mean_sui = mean(SUI, na.rm = TRUE))
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



## Join SVI and SUI by categories for treemap, proportional charts, etc
join_svi_sui <- function(svi_in, sui_in){
  join_data <- sui_in |>
    inner_join(svi_in |> drop_na(), by = "HUC8") |>
    mutate(svi_category = case_when(mean_svi <= 0.334 ~ "Low SVI",
                                    mean_svi <= 0.667 ~ "Moderate SVI",
                                    mean_svi <= 1.0 ~ "High SVI",
                                    TRUE ~ NA),
           sui_category = case_when(mean_sui <= 0.4 ~ "Low SUI",
                                    mean_sui <= 0.6 ~ "Moderate SUI",
                                    mean_sui <= 1.0 ~ "High SUI",
                                    TRUE ~ NA),
           join_category = sprintf("%s-%s", sui_category, svi_category))
  
  group_summary <- join_data |>
    group_by(sui_category) |>
    summarize(n_sui_cat = n())
  
  # summary values for below
  n_high_sui = group_summary$n_sui_cat[group_summary$sui_category == "High SUI"]
  n_mod_sui = group_summary$n_sui_cat[group_summary$sui_category == "Moderate SUI"]
  n_low_sui = group_summary$n_sui_cat[group_summary$sui_category == "Low SUI"]
  
  final_df <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category) |>
    summarize(n_hucs = n())
  
  
}