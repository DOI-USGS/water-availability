mean_sui <- function(data_in,
                     HUC_level, 
                     min_year = NULL, 
                     max_year = NULL,
                     by_yearL = FALSE){
  
  # Clean data
  raw <- data_in |>
    rename(HUC12 = huc) |>
    mutate(year = as.numeric(substr(year_month, 1, 4)),
           HUC8 = substr(HUC12, 1, 8)) 
  
  # Filter by year if min_year and max_year are provided
  if(!is.null(min_year) & !is.null(max_year)) {
    raw <- raw |>
    # Select only focal years
    filter(year >= min_year,
           year <= max_year) 
  }
  
  # create grouping variables
  temp_HUC_colname <- sprintf("HUC%s", HUC_level)
  temp_grouping_vars <- if(by_yearL){
    c(temp_HUC_colname, "year")
  } else {
    c(temp_HUC_colname)
  }
  
  # summarize with grouping variables
  out_mean <- raw |>
    group_by(across(all_of(temp_grouping_vars))) |>
    summarize(mean_sui = mean(SUI, na.rm = TRUE), .groups = "drop")
  
  # add categories
  out_categorized <- out_mean |>
    mutate(sui_category_5  = case_when(mean_sui >= 0 & mean_sui < 0.2 ~ "Very low/\nnone",
                                       mean_sui >= 0.2 & mean_sui < 0.4 ~ "Low",
                                       mean_sui >= 0.4 & mean_sui < 0.6 ~ "Moderate",
                                       mean_sui >= 0.6 & mean_sui < 0.8 ~ "High",
                                       mean_sui >= 0.8 & mean_sui <= 1 ~ "Severe"),
           sui_category_3 = case_when(mean_sui <= 0.4 ~ "Low SUI",
                                      mean_sui <= 0.6 ~ "Medium SUI",
                                      mean_sui <= 1.0 ~ "High SUI",
                                      TRUE ~ NA)) 

  return(out_categorized)
}

