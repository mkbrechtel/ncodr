numcodr_to_dataframes <- function(file_path) {
  # Required libraries
  library(jsonlite)
  library(dplyr)
  
  # Read the JSON file
  json_data <- fromJSON(file_path, simplifyVector = FALSE)
  
  # Extract patients data
  patients <- json_data$patients
  patient_ids <- names(patients)
  
  # Create empty list to store all data frames
  result_dfs <- list()
  
  # Identify all possible table types across all patients and visits
  table_types <- c()
  for (pid in patient_ids) {
    visits <- patients[[pid]]$visits
    visit_ids <- names(visits)
    
    for (vid in visit_ids) {
      # Get all form types in this visit
      visit_forms <- names(visits[[vid]])
      table_types <- union(table_types, visit_forms)
    }
  }
  
  # Process each table type
  for (table_type in table_types) {
    # Create a list to store data for this table type
    table_data_list <- list()
    
    for (pid in patient_ids) {
      visits <- patients[[pid]]$visits
      visit_ids <- names(visits)
      
      for (vid in visit_ids) {
        # Extract visit type and number
        visit_parts <- strsplit(vid, "_")[[1]]
        visit_type <- visit_parts[1]
        visit_number <- as.integer(ifelse(length(visit_parts) > 1, visit_parts[2], NA))
        
        # Check if this table exists in this visit
        if (!is.null(visits[[vid]][[table_type]])) {
          # Extract the data and flatten complex structures
          data <- flatten_nested_data(visits[[vid]][[table_type]])
          
          # Add identifiers
          data <- c(
            list(
              patient_id = pid,
              visit_id = vid,
              visit_type = visit_type,
              visit_number = visit_number
            ),
            data
          )
          
          # Add to the list for this table type
          table_data_list[[length(table_data_list) + 1]] <- data
        }
      }
    }
    
    # Convert the list to a data frame for this table type
    if (length(table_data_list) > 0) {
      # Find all possible column names across all entries
      all_cols <- unique(unlist(lapply(table_data_list, names)))
      
      # Ensure all entries have all columns (fill with NA if missing)
      normalized_list <- lapply(table_data_list, function(entry) {
        for (col in all_cols) {
          if (is.null(entry[[col]])) {
            entry[[col]] <- NA
          }
        }
        return(entry)
      })
      
      # Now convert to data frame
      result_dfs[[table_type]] <- bind_rows(lapply(normalized_list, as.data.frame))
    }
  }
  
  return(result_dfs)
}

# Helper function to flatten nested data structures
flatten_nested_data <- function(data) {
  result <- list()
  
  for (name in names(data)) {
    value <- data[[name]]
    
    if (is.list(value)) {
      if (length(value) > 0) {
        # Check if this is a simple array
        if (is.null(names(value))) {
          # Convert array to string
          result[[name]] <- paste(unlist(value), collapse = ", ")
        } else {
          # For nested objects, flatten with prefixed names
          nested <- flatten_nested_data(value)
          for (nested_name in names(nested)) {
            result[[paste0(name, "_", nested_name)]] <- nested[[nested_name]]
          }
        }
      } else {
        result[[name]] <- NA
      }
    } else {
      # Simple value
      result[[name]] <- value
    }
  }
  
  return(result)
}
