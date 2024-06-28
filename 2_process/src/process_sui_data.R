mean_sui <- function(data_in,
                     HUC_level, 
                     thresholds,
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
    mutate(sui_category = case_when(mean_sui <= thresholds$lower ~ "Low SUI",
                                    mean_sui <= thresholds$upper ~ "High SUI",
                                    TRUE ~ NA)) 

  return(out_categorized)
}

