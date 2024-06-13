mean_sui <- function(data_in, 
                     thresholds,
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
  
  out_df <- raw_mean |> 
    mutate(sui_category = case_when(mean_sui <= thresholds$lower ~ "Low SUI",
                                    mean_sui <= thresholds$upper ~ "Moderate SUI",
                                    mean_sui <= 1.0 ~ "High SUI",
                                    TRUE ~ NA))
    
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
      summarize(mean_sui = mean(SUI, na.rm = TRUE)) 
  } else if(HUC_level == 8){
    raw_mean <- raw |>
      group_by(HUC8, year) |>
      summarize(mean_sui = mean(SUI, na.rm = TRUE)) 
  }
  
  raw_mean_wide <- raw_mean |>
    pivot_wider(names_from = year,
                names_prefix = "sui_",
                values_from = mean_sui)
}



## Join SVI and SUI by categories for treemap, proportional charts, etc
join_svi_sui <- function(svi_in, sui_in){
  
  # thresholds that change the binning. 0.4/0.6 are what IWAAs uses
  threshold_lower_sui <- 0.5 # 0.4 for IWAAs (three categories)
  threshold_upper_sui <- 1.0 # 0.6 for IWAAs (three categories)
  
  join_data <- sui_in |>
    inner_join(svi_in |> drop_na(), by = "HUC8") |>
    mutate(join_category = sprintf("%s-%s", sui_category, svi_category),
           join_category1 = sprintf("%s-%s", sui_category, svi1_category),
           join_category2 = sprintf("%s-%s", sui_category, svi2_category),
           join_category3 = sprintf("%s-%s", sui_category, svi3_category),
           join_category4 = sprintf("%s-%s", sui_category, svi4_category))
           
  
  
  overall_means_df <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category, svi_category, sui_category) |>
    summarize(n_hucs = n())
  
  theme1_means <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category1) |>
    summarize(n1_hucs = n()) |>
    rename(join_category = join_category1)
  
  theme2_means <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category2) |>
    summarize(n2_hucs = n()) |>
    rename(join_category = join_category2)
  
  theme3_means <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category3) |>
    summarize(n3_hucs = n()) |>
    rename(join_category = join_category3)
  
  theme4_means <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category4) |>
    summarize(n4_hucs = n()) |>
    rename(join_category = join_category4)
  
  out_df <- overall_means_df |>
    left_join(theme1_means, by = "join_category") |>
    left_join(theme2_means, by = "join_category") |>
    left_join(theme3_means, by = "join_category") |>
    left_join(theme4_means, by = "join_category") 
    
  
}