prep_wq_for_sankey <- function(data_in, unimpair_miles){
  raw_data <- readr::read_csv(data_in,
                              show_col_types = FALSE)
  
  # join the unimpaired river miles
  joined_data <- raw_data |>
    select(use_name, Category, parameter, sum_watersize) |>
    bind_rows(unimpair_miles)
  
  # calculate total miles
  summary_data <- joined_data |>
    group_by(use_name) |>
    summarize(total_miles = sum(sum_watersize, na.rm = TRUE)) 
  
  # join back to data, calculate percent miles
  out_data <- joined_data |> left_join(summary_data, by = "use_name") |>
    mutate(percent_miles = round((sum_watersize / total_miles)*100, 1),
           sum_watersize = round(sum_watersize, 0)) |>
    # clean up names for d3
    rename(Use = use_name,
           Parameter = parameter,
           riverMiles = sum_watersize,
           totalMiles = total_miles,
           percentMiles = percent_miles) |>
    # add overall status as another link
    mutate(Status = case_when(Category == "Unimpaired" ~ "Unimpaired",
                              TRUE ~ "Impaired")) |>
    mutate(Category = case_when(Category == "Temp" ~ "Temperature",
                                TRUE ~ Category)) |>
    mutate(Parameter = case_when(Category == "Salinity" ~ "Salinity",
                                 TRUE ~ Parameter)) |>
    mutate(Category = case_when(Category == "Metals and Physical" ~ "Metals",
                                TRUE ~ Category)) |>
    # order the columns -- 
    #     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #     NOTE: Changing these can affect the sankey plot in keyfinding06WQThreats.vue
    select(Use, Category, Parameter, riverMiles) |>
    # add abbreviation for split() function to write to csv
    mutate(UseAbbr = case_when(Use == "Drinking Water Use" ~ "DW",
                               Use == "Ecological Use" ~ "Eco",
                               Use == "Recreational Use" ~ "Rec",
                               Use == "Fish Consumption Use" ~ "Fish",
                               Use == "Other Use" ~ "Other")) |>
    arrange(-riverMiles)
}