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


summary_wq_by_state <- function(in_sf, nutrient, out_csv){
  
  load_column <- sym(ifelse(nutrient == "tn", "tn_load", "tp_load"))
  
  # set load level breaks
  if(nutrient == "tn") {
    breaks <- c(100, 500, 1000, 2000, 3000, 6000, 12000, 30000, 120000, Inf)
    labels <- c("0 - 100", "100 - 500", "500 - 1000", "1000 - 2000", "2000 - 3000", 
                "3000 - 6000", "6000 - 12000", "12000 - 30000", ">30000")
  } else {
    breaks <- c(10, 40, 85, 160, 290, 520, 1000, 2500, 10000, Inf)
    labels <- c("0 - 10", "10 - 40", "40 - 85", "85 - 160", "160 - 290", 
                "290 - 520", "520 - 1000", "1000 - 2500", ">2500")
  }
  
  # categorize load levels
  category_sf <- in_sf |> 
    filter(!is.na(!!load_column)) |> 
    mutate(load_level = cut(!!load_column, breaks = breaks, labels = labels))
  
  # Expand each HUC to its state (some hucs overlap states)
  expand_states <- category_sf |>
    select(STATES, HUC12, Region_nam, AggReg_nam, !!load_column, load_level) |>
    separate_rows(STATES, sep = ",")
  
  # Calculate total number of HUCS per state
  HUC_per_state <- expand_states |> 
    sf::st_drop_geometry() |>
    group_by(STATES) |>
    mutate(total_hucs = n()) |>
    ungroup()
  
  # Calculate total hucs in each sui category by state and proportion
  summary_out <- HUC_per_state |>
    group_by(load_level, STATES, total_hucs) |>
    summarize(n_cat = n()) |>
    mutate(prop_cat = n_cat / total_hucs) |>
    rename(d3_percentage = prop_cat,
           d3_category = load_level) |>
    ungroup() |>
    complete(STATES, d3_category)
  
  
  # save to csv
  readr::write_csv(summary_out, file = out_csv)
  
}

summary_wq_by_region <- function(in_sf, nutrient, out_csv){
  
  load_column <- sym(ifelse(nutrient == "tn", "tn_load", "tp_load"))
  
  # set load level breaks
  if(nutrient == "tn") {
    breaks <- c(100, 500, 1000, 2000, 3000, 6000, 12000, 30000, 120000, Inf)
    labels <- c("0 - 100", "100 - 500", "500 - 1000", "1000 - 2000", "2000 - 3000", 
                "3000 - 6000", "6000 - 12000", "12000 - 30000", ">30000")
  } else {
    breaks <- c(10, 40, 85, 160, 290, 520, 1000, 2500, 10000, Inf)
    labels <- c("0 - 10", "10 - 40", "40 - 85", "85 - 160", "160 - 290", 
                "290 - 520", "520 - 1000", "1000 - 2500", ">2500")
  }
  
  # categorize load levels
  category_sf <- in_sf |> 
    filter(!is.na(!!load_column)) |> 
    mutate(load_level = cut(!!load_column, breaks = breaks, labels = labels))
  
  # summarize by region and category
  region_summary <- category_sf |>
    sf::st_drop_geometry() |>
    rename(load = !!load_column) |>
    select(HUC12, Region_nam, AggReg_nam, load, load_level, Area_sqkm) |>
    group_by(Region_nam, AggReg_nam, load_level) |>
    summarize(category_hucs = n(),
              category_sqkm = sum(Area_sqkm, na.rm = TRUE),
              total_load = round(sum(load, na.rm = TRUE), 4))
  
  # Calculate total number of HUCS per state
  HUC_per_region <- category_sf |> 
    sf::st_drop_geometry() |>
    group_by(Region_nam) |>
    summarize(total_hucs = n(),
              total_sqkm = sum(Area_sqkm, na.rm = TRUE)) 
  
  # Calculate total hucs in each sui category by state and proportion
  summary_out <- region_summary |>
    left_join(HUC_per_region, by = "Region_nam") |>
    mutate(prop_cat = round((category_hucs / total_hucs), 4),
           prop_sqkm = round((category_sqkm / total_sqkm), 4)) |>
    rename(d3_percentage = prop_cat,
           d3_category = load_level) |>
    ungroup() |>
    complete(d3_category, Region_nam,
             fill = list(d3_percentage = 0,
                         category_hucs = 0,
                         total_load = 0,
                         prop_sqkm = 0))
  
  
  
  # save to csv
  readr::write_csv(summary_out, file = out_csv)
  
}