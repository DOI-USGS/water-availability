#' Initialize ScienceBase session and download files (large zipped files only)
#'
#' @param gbd_file chr; location of geodatabase
#' @param layer chr; which layer to convert to sf
#' @param crs_out chr; crs for output sf
#' @param exclude_non_plot_hucs  logical, do you want to overwrite file?
#'
#' @return sf
#' 
prep_sf <- function(gdb_file,
                    layer, #ex "WBDHU8"
                    crs_out,
                    exclude_non_plot_hucs = TRUE){
  
  temp_file <- tempfile(fileext = ".gpkg")
  
  sf::gdal_utils(util = "vectortranslate", 
                 source = gdb_file, 
                 destination = temp_file, 
                 options = c(layer, "-nlt", "MULTIPOLYGON"))
  
  huc_sf <- read_sf(temp_file, layer = layer) |>
    select(-TNMID, -METASOURCEID, -SOURCEDATADESC, -SOURCEORIGINATOR,
           -SOURCEFEATUREID, -LOADDATE, -GLOBALID
    ) |>
    rename_with(.cols = starts_with("huc"), function(.){
      "HUC"
    })
  
  # Remove great lakes and shorelines
  if(exclude_non_plot_hucs) {
    
    huc_exclusions <- c(
      # Great lakes
      "041800000200", "041900000200", "042400000200", "042600000200",
      "041502000200",
      "04180000", "04190000", "04240000", "04260000",  "04150200",
      
      # Great Salt Lake
      "160203100200",
      "16020310",
      
      # Great Lakes shorelines
      "041505000000", "042701010000", "041502000100", "041506000000",
      "042600000101", "041800000101", "041800000102", "090300091423",
      "041503090407", "042400000102", "042400000101", "042600000102"
    )
    
    huc_sf <- huc_sf |> 
      filter(
        ! STATES %in% c("MX", "CN"),
        ! HUC %in% huc_exclusions
      )
    
    ######################################
    # Merge polygons with duplicate HUCS #
    ######################################
    # Identify duplicate HUCs
    dup_hucs <- huc_sf %>%
      filter(duplicated(HUC)) %>%
      pull(HUC)
    
    if (length(dup_hucs) == 0) {
      
      # return(huc_sf)
      huc_out <- huc_sf
      
    } else {
      dup_data <- huc_sf %>%
        filter(HUC %in% dup_hucs) %>%
        group_by(HUC)
      
      # Error if data from duplicate HUCS differs
      duplicate_huc_count <- dup_data %>%
        st_drop_geometry() %>%
        summarise(across(where(~ !is.numeric(.x)), ~ n_distinct(.x))) %>%
        dplyr::select(where(is.numeric)) %>%
        as.matrix() %>%
        min()
      
      if (duplicate_huc_count > 1) {
        stop("Rows with duplicate HUCs contain data that differs")
      }
      
      # Merge duplicate HUC geometries
      merged_geom <- dup_data %>%
        summarize() %>%
        st_geometry()
      
      # Aggregate WBD data and set the geometry
      # Numeric data is summed; the first observation is used for non-numeric data
      merged_data <- dup_data %>%
        st_drop_geometry() %>%
        summarise(
          across(where(is.numeric), ~ sum(.x, na.rm = TRUE)),
          across(where(~ !is.numeric(.x)), ~ first(.x))
        ) %>%
        dplyr::select(colnames(st_drop_geometry(huc_sf))) %>%
        st_set_geometry(merged_geom) %>%
        rename(SHAPE = geometry)
      
      # Add merged duplicates back into full dataset
      huc_out <- huc_sf %>%
        filter(!HUC %in% dup_hucs) %>%
        bind_rows(merged_data) %>%
        arrange(HUC)
    }
    
    
    
  }
  # Ensure consistent geometry
  huc_out <- sf::st_cast(huc_out, "MULTIPOLYGON")
  
  # Transform data
  if(is.null(crs_out)) crs_out <- st_crs(huc_out)
  
  if(st_crs(huc_out) != st_crs(crs_out)) {
    
    message("Reprojecting `huc_path` to `crs_out`")
    
    huc_out <- terra::vect(huc_out) |> 
      terra::project(y = crs_out) |> 
      st_as_sf()
    
  }
  
  return(huc_out)
  
  
}

#' Unzip zip files and return file paths
#'
#' @param zip_files character; vector of zip file paths to unzip
#' @param path_out character; string of the path to unzip files to
#' @param unzip_file_pattern character; REGEX pattern used to identify the files
#'   in each zip file that should be unzipped. If NULL, all files returned.
#' @param file_out_pattern character; REGEX pattern used to identify which
#'   unzipped files should be listed in the output vector. To return the parent
#'   directory of the output files (useful for .gdb geodatabase files), use
#'    `".."`.
#'
#' @return A character vector of  files paths (or a subset of them if
#'   file_out_pattern is specified) of unzipped files
#'
unzip_files <- function(zip_files, path_out, unzip_file_pattern = NULL,
                        file_out_pattern = "|") {
  # List files that should be unzipped
  files_to_unzip <- purrr::map(
    zip_files,
    ~ index_zipped_files(.x, unzip_file_pattern)
  )
  
  # Unzip files
  files_out <- purrr::map2(
    zip_files,
    files_to_unzip,
    ~ archive::archive_extract(
      archive = .x,
      dir = path_out,
      files = .y
    )
  )
  
  # Output only the those unzipped files that are specified with
  #   file_out_pattern argument
  if (file_out_pattern == "..") {
    
    out <- file.path(path_out, str_remove(files_out[[1]][1], "/[^ ]+$"))
    
  } else {
    
    out <- file.path(path_out, str_subset(unlist(files_out), file_out_pattern))
    
  }
  
  return(out)
  
}

#' Get index files matching pattern within archive
#' 
#' Helper for `unzip_files`
#'
#' @param zip_files character; vector of zip file paths to unzip
#' @param unzip_file_pattern character; REGEX pattern used to identify the files
#'   in each zip file that should be unzipped. If NULL, NULL is returned.
#'
#' @return num; index of files matching pattern within archive
#' 
index_zipped_files <- function(zip_files, unzip_file_pattern = NULL) {
  if(is.null(unzip_file_pattern)) return(NULL)
  
  archive::archive(zip_files)$path |> 
    str_detect(unzip_file_pattern) |> 
    which()
}

