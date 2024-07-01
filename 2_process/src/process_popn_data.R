clean_popn_data <- function(popn_in,
                            crosswalk_in){
  
  # Clean crosswalk data
  crosswalk_clean <- read_csv(crosswalk_in, show_col_types = FALSE) |>
    rename(sys_id = wsa_agidf,
           HUC12 = huc12) |>
    distinct(sys_id, .keep_all = TRUE)
  
  # Clean population data
  popn_raw <- readr::read_csv(popn_in,
                              show_col_types = FALSE) |>
    rename(popn = pop)
  
  # Join crosswalk to population data
  popn_join <- popn_raw |>
    left_join(crosswalk_clean, by = "sys_id") |>
    filter(Year == 2020) |>
    select(-wu_frac, -est_per_capita, -sys_id, -Year) 
  
  # summarize by HUC8
  popn_huc8 <- popn_join |>
    group_by(HUC12) |>
    summarize(popn_huc = sum(popn, na.rm = TRUE)) |>
    select(HUC12, popn_huc)
  
  return(popn_huc8)
}


join_popn_to_sui <- function(sui_in, popn_in, region_xwalk){
  
  # join data sets
  sui_popn_join <- sui_in |>
    inner_join(popn_in, by = "HUC12") |>
    # reclassify water stress
    mutate(sui_category = case_when(mean_sui >= 0 & mean_sui < 0.2 ~ "Very low/\nnone",
                                 mean_sui >= 0.2 & mean_sui < 0.4 ~ "Low",
                                 mean_sui >= 0.4 & mean_sui < 0.6 ~ "Moderate",
                                 mean_sui >= 0.6 & mean_sui < 0.8 ~ "High",
                                 mean_sui >= 0.8 & mean_sui <= 1 ~ "Severe"),
           sui_factor = factor(sui_category,
                               levels = c("Severe", "High", "Moderate", 
                                          "Low", "Very low/\nnone"))) |>
    # prepare for bubble packing
    arrange(sui_factor) |>
    mutate(label_pop = ifelse(popn_huc > 1500000, pretty_num(popn_huc), NA))
  
  sui_popn_AggReg <- sui_popn_join |>
    inner_join(region_xwalk, by = "HUC12")
  
}