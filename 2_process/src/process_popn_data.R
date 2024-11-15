clean_popn_data <- function(popn_in,
                            crosswalk_in){
  
  # Clean population data
  popn_raw <- readr::read_csv(popn_in,
                              show_col_types = FALSE) |>
    rename(HUC12 = WBDHU12_HUC12,
           popn = UStracts_csv_P1_001N)
  
  # Join crosswalk to population data
  popn_join <- popn_raw |>
    inner_join(crosswalk_in, by = "HUC12") |>
    select(-WBDHU12_NAME, OID_) 
  
  return(popn_join)
}


join_popn_to_sui <- function(sui_in, popn_in){
  
  # join data sets
  sui_popn_join <- sui_in |>
    inner_join(popn_in, by = "HUC12") |>
    mutate(sui_factor = factor(sui_category_5,
                               levels = c("Severe", "High", "Moderate", 
                                          "Low", "Very low/\nnone"))) |>
    # prepare for bubble packing
    arrange(sui_factor) |>
    mutate(label_pop = ifelse(popn > 1500000, pretty_num(popn), NA))
  
  return(sui_popn_join)
  
}

popn_for_bar <- function(in_df){
  
  # prep data for proportion bar (summed to each SUI class)
  total_bar_height = sum(in_df$popn, na.rm = TRUE)
  
  reg_part_to_whole_summed <- in_df |>
    #filter(if(region == "CONUS") TRUE else AggReg_nam_nospace == region) |>
    group_by(sui_factor) |>
    summarize(sum_pop = sum(popn, na.rm = TRUE)) |>
    ungroup() |>
    mutate(year = "2020") 
  
  reg_part_to_whole_prop <- reg_part_to_whole_summed |>
    arrange(rev(sui_factor), .by_group = TRUE) |>
    mutate(pos = cumsum(sum_pop) - sum_pop/2,
           ymax = cumsum(sum_pop)) |>
    arrange(sui_factor) |>
    mutate(label_pop = prettyunits::pretty_num(sum_pop)) |> 
    mutate(label_pop = as.numeric(str_sub(label_pop, end = -2))) |> 
    mutate(label_pop = paste0(round(label_pop, digits = 0), " M")) |> 
    mutate(total_bar_height = total_bar_height)
}