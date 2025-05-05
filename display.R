# Source the loader script
source("numcodr-loader.R")

# Load all data frames from the JSON file
data_frames <- numcodr_to_dataframes("example-dataset.numcodr.json")

# Display all data frame names
cat("Created data frames:\n")
df_names <- names(data_frames)
cat(paste("-", df_names, collapse = "\n"), "\n\n")

# Display summary information for each data frame
for (df_name in df_names) {
  cat(paste0("== ", df_name, " ==\n"))
  df <- data_frames[[df_name]]
  cat("Dimensions:", dim(df)[1], "rows,", dim(df)[2], "columns\n")
  cat("Column names:", paste(names(df), collapse=", "), "\n")

  # Show first few rows if available
  if (nrow(df) > 0) {
    cat("First row preview:\n")
    print(head(df, 1))
  }
  cat("\n")
}