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
    mutate(Parameter = case_when(Parameter == "Metals Other than Mercury" ~ "Other Metals",
                                 TRUE ~ Parameter)) |>
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

summary_wq_by_area <- function(in_sf, nutrient, out_csv, by = c("region", "state")){
  by <- match.arg(by)
  
  load_column <- sym(ifelse(nutrient == "tn", "tn_load", "tp_load"))
  
  # set load level breaks
  if(nutrient == "tn") {
    breaks <- c(100, 500, 1000, 2000, 3000, 6000, 12000, 30000, 120000)
  } else {
    breaks <- c(10, 40, 85, 160, 290, 520, 1000, 2500, 10000)
  }
  
  # calculate lower bounds based on breaks
  lower_breaks <- c(0, head(breaks, -1))
  upper_breaks <- breaks
  labels <- paste0(lower_breaks, " - ", upper_breaks)
  
  # categorize load levels
  category_sf <- in_sf |> 
    filter(!is.na(!!load_column)) |> 
    mutate(load_level = cut(!!load_column, 
                            breaks = c(0, breaks, Inf), 
                            labels = c(labels, paste0(">", max(breaks))), right = FALSE))
  
  # determine grouping column
  group_col <- if (by == "state") "STATES" else "Region_nam"
  
  if(by == "state") {
    category_sf <- category_sf |> separate_rows(STATES, sep = ",")
  }
  
  # calculate summaries
  summary_data <- category_sf |> 
    sf::st_drop_geometry() |> 
    group_by(!!sym(group_col), load_level) |> 
    summarize(category_hucs = length(unique(HUC12)),
              category_sqkm = sum(Area_sqkm, na.rm = TRUE),
              total_load = round(sum(!!load_column, na.rm = TRUE), 4)) |> 
    ungroup() |> 
    complete(!!sym(group_col), load_level, 
             fill = list(category_hucs = 0, 
                         category_sqkm = 0, 
                         total_load = 0))
  
  total_summary <- category_sf |> 
    sf::st_drop_geometry() |> 
    group_by(!!sym(group_col)) |> 
    summarize(total_hucs = length(unique(HUC12)),
              total_sqkm = sum(Area_sqkm, na.rm = TRUE))
  
  # merge summaries and calculate proportions for areas
  summary_out <- summary_data |> 
    left_join(total_summary, by = group_col) |> 
    mutate(prop_sqkm = round((category_sqkm / total_sqkm), 4),
           d3_percentage = round((category_hucs / total_hucs), 4)) |> 
    ungroup() 
  
  # add total row for the United States 
  category_total <- category_sf |>
    sf::st_drop_geometry() |> 
    summarize(
      !!sym(group_col) := "United States",
      total_hucs = length(unique(HUC12)),
      total_sqkm = sum(Area_sqkm, na.rm = TRUE)) 
  
  us_total <- category_sf |> 
    sf::st_drop_geometry() |> 
    group_by(load_level) |> 
    summarize(
      !!sym(group_col) := "United States",
      category_hucs = length(unique(HUC12)),
      category_sqkm = sum(Area_sqkm, na.rm = TRUE)) |>
    left_join(category_total) |>
    mutate(
      prop_sqkm = round(category_sqkm / total_sqkm, 4),
      d3_percentage = round(category_hucs / total_hucs, 4)
    )
  
  summary_out <- bind_rows(summary_out, us_total) |>
    rename(d3_category = load_level)
  
  # save to csv
  readr::write_csv(summary_out, file = out_csv)
}
