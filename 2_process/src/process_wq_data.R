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
    mutate(percent_miles = (sum_watersize / total_miles)*100) |>
    # clean up names for d3
    rename(Use = use_name,
           Parameter = parameter,
           riverMiles = sum_watersize,
           totalMiles = total_miles,
           percentMiles = percent_miles)
}