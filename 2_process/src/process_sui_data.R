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
    mutate(sui_category_5  = case_when(mean_sui >= 0 & mean_sui <= 0.2 ~ "Very low/\nnone",
                                       mean_sui > 0.2 & mean_sui <= 0.4 ~ "Low",
                                       mean_sui > 0.4 & mean_sui <= 0.6 ~ "Moderate",
                                       mean_sui > 0.6 & mean_sui <= 0.8 ~ "High",
                                       mean_sui > 0.8 & mean_sui <= 1 ~ "Severe"),
           sui_category_3 = case_when(mean_sui <= 0.4 ~ "Low SUI",
                                      mean_sui <= 0.6 ~ "Medium SUI",
                                      mean_sui <= 1.0 ~ "High SUI",
                                      TRUE ~ NA)) 

  return(out_categorized)
}

process_supply_v_demand <- function(data_path){
  
  raw_data <- readr::read_csv(data_path,
                              show_col_types = FALSE)
  
  out_data <- raw_data |>
    group_by(Region_nam) |>
    summarise(supply_mean = mean(regionSupply_mm),
              supply_sd = sd(regionSupply_mm),
              supply_lower = supply_mean - supply_sd,
              supply_upper = supply_mean + supply_sd,
              demand_mean = mean(regionDemand_mm),
              demand_sd = sd(regionDemand_mm),
              demand_lower = demand_mean - demand_sd,
              demand_upper = demand_mean + demand_sd) |>
    arrange(-supply_mean)
  
  return(out_data)
  
}

create_stats <- function(in_sf, out_csv){
  
  in_df <- in_sf |> 
    sf::st_drop_geometry() 
  
  stress_by_reg <- in_df |> 
    filter( ! is.na(sui_category_5)) |>
    group_by(Region_nam, sui_category_5) |>
    summarize(stress_by_reg = n()) 
  
  total_huc_by_reg <- in_df |>
    filter( ! is.na(sui_category_5)) |>
    group_by(Region_nam) |>
    summarize(total_hucs = n())
  
  join_data <- stress_by_reg |>
    left_join(total_huc_by_reg, by = "Region_nam") |>
    mutate(percentage_stress = (stress_by_reg / total_hucs)*100) 
  
  expand_data <- expand.grid(sui_category_5 = unique(join_data$sui_category_5), 
              Region_nam = unique(join_data$Region_nam)) |>
    left_join(join_data) |>
    mutate(percentage_stress = ifelse(is.na(percentage_stress), 0, percentage_stress),
           stress_by_reg = ifelse(is.na(stress_by_reg), 0, stress_by_reg),
           total_hucs = ifelse(is.na(total_hucs), 0, total_hucs))
  
  readr::write_csv(expand_data, file = out_csv)
}


summary_sui_by_state <- function(in_sf){
  
  # Expand each HUC to its state (some hucs overlap states)
  expand_states <- in_sf |>
    select(STATES, HUC12, Region_nam, AggReg_nam, mean_sui, sui_category_5) |>
    filter(! is.na(mean_sui)) |>
    separate_rows(STATES, sep = ",")
  
  # Calculate total number of HUCS per state
  HUC_per_state <- expand_states |> 
    sf::st_drop_geometry() |>
    group_by(STATES) |>
    mutate(total_hucs = n()) |>
    ungroup()
  
  # Calculate total hucs in each sui category by state and proportion
  summary_sui <- HUC_per_state |>
    group_by(sui_category_5, STATES, total_hucs) |>
    summarize(n_cat_sui = n()) |>
    mutate(prop_cat_sui = n_cat_sui / total_hucs)
    
}
