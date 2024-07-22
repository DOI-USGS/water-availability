mean_svi <- function(data_in,
                     HUC_level,
                     thresholds){
  
  # Clean data
  raw <- data_in |>
    mutate(HUC8 = substr(HUC12, 1, 8)) 
  

  # create grouping variables
  temp_HUC_colname <- sprintf("HUC%s", HUC_level)

  
  # summarize with grouping variables
  out_mean <- raw |>
    group_by(!!sym(temp_HUC_colname)) |>
    summarize(mean_svi = mean(overall_weighted_SVI, na.rm = TRUE), 
              mean_svi_theme1 = mean(theme1_weighted_SVI, na.rm = TRUE),
              mean_svi_theme2 = mean(theme2_weighted_SVI, na.rm = TRUE),
              mean_svi_theme3 = mean(theme3_weighted_SVI, na.rm = TRUE),
              mean_svi_theme4 = mean(theme4_weighted_SVI, na.rm = TRUE),
              .groups = "drop")
  
  # add categories
  out_categorized <- out_mean |>
    mutate(svi_category = case_when(mean_svi <= thresholds$lower ~ "Low SVI",
                                    mean_svi <= thresholds$upper ~ "Moderate SVI",
                                    mean_svi <= 1.0 ~ "High SVI",
                                    TRUE ~ NA)) 

  return(out_categorized)
}

## Join SVI and SUI by categories for treemap, proportional charts, etc
join_svi_sui <- function(svi_in, sui_in, HUC_level){
  
  # create joining variables
  temp_HUC_colname <- sprintf("HUC%s", HUC_level)
  
  # establish categories
  join_data <- sui_in |>
    inner_join(svi_in |> drop_na(), by = temp_HUC_colname) |>
    mutate(join_category = sprintf("%s-%s", sui_category_3, svi_category))
  
  
  
  overall_means_df <- join_data |>
    # now get n by SVIxSUI categories, plus proportions
    group_by(join_category, svi_category, sui_category_3) |>
    summarize(n_hucs = n())
  
  return(overall_means_df)
  
  
}
