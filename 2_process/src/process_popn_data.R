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

popn_for_bubbles <- function(in_df, in_sf){
  # remove unnecessary columns of in_df
  df_simpler <- in_df |>
    select(HUC8, mean_sui, sui_category_5, popn) |>
    filter(!is.na(popn)) |>
    group_by(HUC8) |>
    summarize(mean_sui = mean(mean_sui, na.rm = TRUE),
              total_popn = sum(popn, na.rm = TRUE))
  
  # join data to sf
  plot_sf <- in_sf |>
    left_join(df_simpler, by = "HUC8") |>
    select(HUC8, geometry, mean_sui, total_popn) |>
    filter(! is.na(total_popn))
  
  # create cartogram
  st_cartogram <- cartogram::cartogram_dorling(plot_sf, 
                                               weight = "total_popn",
                                               m_weight = 0)
  
  # set up categories of water limitation
  st_cartogram <- st_cartogram |>
    mutate(sui_category_5 = case_when(mean_sui >= 0 & mean_sui <= 0.2 ~ "Very low/\nnone",
                                      mean_sui > 0.2 & mean_sui <= 0.4 ~ "Low",
                                      mean_sui > 0.4 & mean_sui <= 0.6 ~ "Moderate",
                                      mean_sui > 0.6 & mean_sui <= 0.8 ~ "High",
                                      mean_sui > 0.8 & mean_sui <= 1 ~ "Severe"))
}