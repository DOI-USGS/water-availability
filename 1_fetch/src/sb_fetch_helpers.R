#' Initialize ScienceBase session and download files (large zipped files only)
#'
#' @param sb_id chr; ScienceBase ID
#' @param unzip_file_to_check chr; names of unzipped child targets to check against
#' @param names chr; names of files to download from ScienceBase
#' @param destinations  chr; write path location for downloaded files
#' @param overwrite_destinationL logical, do you want to overwrite file?
#' @param renviron_file chr; path to .Renviron file where credentials are cached
#' @param ... additional arguments passed to `sbtools::item_file_download()`
#'
#' @return chr; path to downloaded files
#' 
sb_initialize_and_download_zipped <- function(sb_id, 
                                              unzip_file_to_check, 
                                              names, 
                                              destination_zip,
                                              download_dir, 
                                              overwrite_fileL,
                                              renviron_file = ".Renviron", ...) {
  
  # Does destination file already exist?
  does_file_exist <- file.exists(unzip_file_to_check)
  
  # If the destination file does exist, check dates before downloading
  if(does_file_exist){
    
    # Initialize ScienceBase session
    sb_login_cached(renviron_file = renviron_file)
    
    item_metadata <- sbtools::item_get(sb_id)$files
    
    file_index <- purrr::map(item_metadata, `[`, "name") |>
      unlist(use.names = FALSE) |>
      purrr::map_lgl(~ .x == names) |>
      which()
    
    file_metadata <- item_metadata[[file_index]]
    
    # If no hash is available check dates:
    # Get upload date from SB
    ul_time <- file_metadata$dateUploaded |>
      as.POSIXct(format = "%Y-%m-%dT%T", tz = "UTC")
    
    # Get download date
    dl_time <- file.info(unzip_file_to_check)$mtime |>
      `attr<-`("tzone", "UTC")
    
    download_needed <- ul_time > dl_time
    
    if(download_needed){
      # Download SB files
      sbtools::item_file_download(
        sb_id = sb_id,
        names = names,
        destinations = destination_zip,
        overwrite_file = TRUE,
        ...
      )
      
      unzip(zipfile = destination_zip, 
            overwrite = overwrite_fileL,
            exdir = download_dir)
      
      file.remove(destination_zip)
    }
  } else {
    # file doesn't yet exist, so download
    sbtools::item_file_download(
      sb_id = sb_id,
      names = names,
      destinations = destination_zip,
      overwrite_file = overwrite_fileL,
      ...
    )
    
    unzip(zipfile = destination_zip, 
          overwrite = overwrite_fileL,
          exdir = download_dir)
    
    file.remove(destination_zip)
  }
  
  return(unzip_file_to_check)
  
}


#' Initialize ScienceBase session and download files (large zipped files only)
#'
#' @param sb_id chr; ScienceBase ID
#' @param unzip_file_to_check chr; names of unzipped child targets to check against
#' @param names chr; names of files to download from ScienceBase
#' @param destinations  chr; write path location for downloaded files
#' @param overwrite_destinationL logical, do you want to overwrite file?
#' @param renviron_file chr; path to .Renviron file where credentials are cached
#' @param ... additional arguments passed to `sbtools::item_file_download()`
#'
#' @return chr; path to downloaded files
#' 
sb_initialize_and_download <- function(sb_id, 
                                       names, 
                                       destinations, 
                                       overwrite_fileL,
                                       renviron_file = ".Renviron", ...) {
  
  # Does destination file already exist?
  does_file_exist <- file.exists(destinations)
  
  # Initialize ScienceBase session
  sb_login_cached(renviron_file = renviron_file)
  
  if(does_file_exist){

    
    item_metadata <- sbtools::item_get(sb_id)$files
    
    file_index <- purrr::map(item_metadata, `[`, "name") |>
      unlist(use.names = FALSE) |>
      purrr::map_lgl(~ .x == names) |>
      which()
    
    file_metadata <- item_metadata[[file_index]]
    
    # If no hash is available check dates:
    # Get upload date from SB
    ul_time <- file_metadata$dateUploaded |>
      as.POSIXct(format = "%Y-%m-%dT%T", tz = "UTC")
    
    # Get download date
    dl_time <- file.info(destinations)$mtime |>
      `attr<-`("tzone", "UTC")
    
    download_needed <- ul_time > dl_time
    
    if(download_needed){
      

      
      # Download SB files
      sbtools::item_file_download(
        sb_id = sb_id,
        names = names,
        destinations = destinations,
        overwrite_file = TRUE
      )
      
    }
  } else {
    
    # file doesn't yet exist, so download
    sbtools::item_file_download(
      sb_id = sb_id,
      names = names,
      destinations = destinations,
      overwrite_file = overwrite_fileL
    )
  }
  
  return(destinations)
  
}


#' Login to ScienceBase using cached credentials
#'
#' @param renviron_file chr; path to .Renviron file
#'
#' @return `TRUE` if logged in. Error if not.
#' 
sb_login_cached <- function(renviron_file) {
  # If logged in, return TRUE and skip the rest
  if(sbtools::is_logged_in()) {
    return(TRUE)
  }
  
  # Try a token refresh
  tryCatch(
    sbtools:::token_refresh(),
    warning = function(x) {},
    error = function(x) FALSE
  )
  
  if(sbtools::is_logged_in()) {
    return(TRUE)
  }
  
  # If .Renviron file does not exist, re-initialize
  if(!file.exists(renviron_file)) {
    cli::cli_abort(c(
      "Could not find the specified file: {.file {renviron_file}}.",
      "i" = "Follow the instructions in {.file README.md} to initalize and cache ScienceBase login credentials."
    ))
  }
  
  # Read .Renviron file
  existing <- readLines(renviron_file)
  sb_token_idx <- which(stringr::str_detect(existing, "^sb_token="))
  sb_username_idx <- which(stringr::str_detect(existing, "^sb_username="))
  
  # If SB credentials not found, throw error
  if(any(length(sb_token_idx) == 0, length(sb_username_idx) == 0)) {
    cli::cli_abort(c(
      "Could not find the username or token in the specified file: {.file {renviron_file}}.",
      "i" = "Follow the instructions in {.file README.md} to re-initalize and cache ScienceBase login credentials."
    ))
  }
  
  # Get ScienceBase credentials
  sb_token <- stringr::str_remove(existing[sb_token_idx], "^sb_token=")
  sb_username <- stringr::str_remove(existing[sb_username_idx], "^sb_username=")
  
  # Initialize ScienceBase session with cached credentials
  sbtools::initialize_sciencebase_session(
    username = sb_username,
    token_text = sb_token
  )
  
  if(sbtools::is_logged_in()) {
    return(TRUE)
  } else {
    cli::cli_abort(c(
      "Could not login to ScienceBase using cached credentials.",
      "i" = "Follow the instructions in {.file README.md} to re-initalize and cache ScienceBase login credentials."
    ))
  }
}

#### Functions from Anthony's water quality pipeline #### 
# https://code.usgs.gov/wma/national-iwaas/NWAA/nwaa-1a-releases/iwaas-sparrow-figures/-/blob/initial-upload/01_fetch.R?ref_type=heads

#' Subset files based on extension and/or pattern
#'
#' Subset a list of files which contain a given file extension and (optionally)
#'   an additional pattern (not case sensitive).
#'
#' @param files Character vector of file pths and names
#' @param extension Character string of file extension.
#' @param pattern (optional) Character. Regex pattern to further subset results.
#'
#' @return Character vector of file paths/names matching all conditions given.
subset_files <- function(files, extension, pattern = NA) {
  out <- files |>
    stringr::str_subset(
      stringr::regex(paste0(extension, "$"), ignore_case = TRUE)
    )
  
  if (!is.na(pattern)) {
    out <- stringr::str_subset(out, stringr::regex(pattern, ignore_case = TRUE))
  }
  
  return(out)
}

#' Arrange input files with order of abbreviated file names
#'
#' @param in_files Character vector of file names
#' @param order_abbr Character vector (same length as `in_files`) containing
#'   abbreviated file names to derive the order from. These abbreviations should
#'   be unique to the file names.
#'
#' @return A character vector of values from `in_files` in the same order as
#'   `order_abbr`
#'
order_from_abbrev <- function(in_files, order_abbr) {
  # Get substrings of in_files that match order_abbr
  in_files_sub_matrix <- purrr::map(basename(in_files), \(x) {
    stringr::str_extract(
      x,
      stringr::regex(paste(order_abbr, sep = "|"), ignore_case = TRUE)
    )
  }
  )
  
  # Return errors if unexpected results
  return_count <- purrr::map_int(in_files_sub_matrix, ~ sum(!is.na(.x)))
  if (any(return_count > 1)) {
    stop("A value in order_abbr appears in multiple filenames.")
  }
  if (any(return_count < 1)) {
    stop("A value in order_abbr doesn't appear in any filenames.")
  }
  
  in_files_subsring <- purrr::map_chr(
    in_files_sub_matrix,
    \(x) x[!is.na(x)]
  )
  # Arrange in_files in the same order as order_abbr
  out <- in_files[order(match(tolower(in_files_subsring), tolower(order_abbr)))]
  
  return(out)
}


#' Create tibble of filenames and hashes
#'
#' Creates a tibble of filenames and hashes for each input file for a given
#'   nutrient. This allows for file hashes to be tracked, ensuring changed files
#'   are invalidated and rebuilt.
#'
#' @param regions A character vector of region names or abbreviations.
#' @param spatial_files A character vector of downloaded spatial file paths.
#' @param tn_files A character vector of downloaded tn file paths.
#' @param tn_cols A character vector of column names for tn load. They should be
#'   in the same order as `regions`.
#' @param tn_abbrev_cols A character vector of prefixes for tn data
#' @param tn_units A character vector of units of `tn_cols` (in the same order).
#'   Data can be found in SPARROW metadata XML file.
#' @param tp_files A character vector of downloaded tp file paths.
#' @param tp_cols A character vector of column names for tp load. They should be
#'   in the same order as `regions`.
#' @param tp_abbrev_cols A character vector of prefixes for tp data
#' @param tp_units A character vector of units of `tp_cols` (in the same order).
#'   Data can be found in SPARROW metadata XML file.
#' @param ss_files A character vector of downloaded ss file paths.
#' @param ss_cols A character vector of column names for ss load. They should be
#'   in the same order as `regions`.
#' @param ss_abbrev_cols A character vector of prefixes for ss data
#' @param ss_units A character vector of units of `ss_cols` (in the same order).
#'   Data can be found in SPARROW metadata XML file.
#' @param flow_files A character vector of file paths for flow data.
#' @param flow_cols A character vector of column names for flow data.
#' @param flow_units A character vector of units for the flow data.
#'
#' @return A tibble of file paths and hashes for each data file for each region
regional_tibble <- function(regions, spatial_files,
                            tn_files, tn_cols, tn_abbrev_cols, tn_units,
                            tp_files, tp_cols, tp_abbrev_cols, tp_units,
                            ss_files, ss_cols, ss_abbrev_cols, ss_units,
                            flow_files, flow_cols, flow_units) {
  # Ensure files are in correct order
  spatial_files <- order_from_abbrev(spatial_files, regions)
  tn_files <- order_from_abbrev(tn_files, regions)
  tp_files <- order_from_abbrev(tp_files, regions)
  ss_files <- order_from_abbrev(ss_files, regions)
  flow_files <- order_from_abbrev(flow_files, regions)
  
  out <- tibble::tibble(
    region = regions,
    spatial_file_path = spatial_files,
    tn_file_path = tn_files,
    tn_col = tn_cols,
    tn_abbrev_col = tn_abbrev_cols,
    tn_unit = tn_units,
    tp_file_path = tp_files,
    tp_col = tp_cols,
    tp_abbrev_col = tp_abbrev_cols,
    tp_unit = tp_units,
    ss_file_path = ss_files,
    ss_col = ss_cols,
    ss_abbrev_col = ss_abbrev_cols,
    ss_unit = ss_units,
    flow_file_path = flow_files,
    flow_col = flow_cols,
    flow_unit = flow_units
  ) |>
    tidytable::mutate(tidytable::across(
      tidyselect::ends_with("path"),
      rlang::hash_file,
      .names = "{.col}_hash"
    )) |>
    tidytable::rename_with(.cols = ends_with("_hash"), stringr::str_remove, "_path")
  
  return(out)
}

# TP, TN, SS processing

#' Create RDS files of TP, TN, SS that include comid, source, source
#' abbreviation, category, and hucs
#'
#' @param var_dic_csv character string of the of path for where
#'   SPARROW_variableNames_grouped_inc.csv lives
#' @param crosswalk path for comid-huc4 dummy crosswalk created in function
#'   above
#' @param vm_crosswalk, path for Van Metre crosswalk that contains region_nam
#'   col for huc12/huc8
#' @param file_tibble A single row of a file tibble that contains the data
#'   needed for this script.
#' @param nutrient chr, one of three nutrients: "tn", "tp", or "ss"
#' @param out_file A character string of the path and name for the RDS to be
#'   output.
#' @return A RDS of assocaited TP, TN or TSS data that includecomid, source,
#'   source abbreviation, catergory, and hucs
process_loads <- function(in_tibble, var_dic_csv, crosswalk, vm_crosswalk,
                          nutrient = c("tn", "tp", "ss")) {
  # load crosswalks
  var_dic <- var_dic_csv |>
    readr::read_csv(skip = 1, col_types = readr::cols()) |>
    dplyr::rename_all(tolower) |>
    dplyr::mutate(region = tolower(region))
  
  comid_huc12_xwalk <- data.table::fread(crosswalk, keepLeadingZeros = TRUE) |>
    tidytable::select(HUC12 = huc12, comid = featureid, weights)
  
  huc12_vm_xwalk <- data.table::fread(
    vm_crosswalk,
    keepLeadingZeros = TRUE,
    skip = 1,
    select = c("HUC12", "Region_nam", "AggRegion_nam")
  ) |>
    tidytable::mutate(
      region_nam = ifelse(Region_nam == "NULL", NA, Region_nam),
      aggregion_nam = ifelse(AggRegion_nam == "NULL", NA, AggRegion_nam),
      .keep = "unused"
    )
  
  comid_vm_xwalk <- tidytable::inner_join(
    comid_huc12_xwalk,
    huc12_vm_xwalk,
    by = "HUC12"
  ) |>
    tidytable::group_by(comid, region_nam, aggregion_nam) |>
    tidytable::summarise(
      weights = sum(weights, na.rm = TRUE),
      .groups = "drop"
    ) |>
    tidytable::filter(max(weights) == weights, .by = comid)
  
  # define columns for selecting
  nutrient_data <- paste0(nutrient, "_file_path")
  nutrient_abbrev <- paste0(nutrient, "_abbrev_col")
  
  # extract data from each regional csv
  data <- purrr::pmap(in_tibble, function(...) {
    regional_subset <- tibble::tibble(...)
    
    out <- regional_subset[[nutrient_data]] |>
      data.table::fread(keepLeadingZeros = TRUE) |>
      tidytable::rename_with(tolower) |>
      tidytable::select(
        comid,
        tidyselect::starts_with(regional_subset[[nutrient_abbrev]])
      ) |>
      tidytable::mutate(region = regional_subset[["region"]], .after = comid) |>
      # convert from wide to long format
      tidyr::pivot_longer(
        cols = tidyselect::starts_with(regional_subset[[nutrient_abbrev]]),
        names_to = "abbreviation",
        values_to = "value"
      )
    
    return(out)
  })
  
  names(data) <- in_tibble[["region"]]
  
  if (nutrient == "ss") {
    data[["pac"]] <- data[["pac"]] |>
      tidytable::mutate(tidytable::across(value, kg_to_MT))
  }
  
  data_long <- tidytable::bind_rows(data)
  
  # join to crosswalk to get huc4
  data_long <- tidytable::left_join(
    data_long,
    var_dic,
    by = c("abbreviation", "region")
  )
  data_long <- tidytable::left_join(data_long, comid_vm_xwalk, by = "comid")
  
  # remove rows having NA
  out <- na.omit(data_long)
  
  return(out)
}

#' Convert kilograms to metric ton
#'
#' @param kg Numeric. Mass in kilograms.
#'
#' @return Numeric. Mass in metric tons.
kg_to_MT <- function(kg) {
  kg * 0.001
}
