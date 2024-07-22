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