# numcodr - Example R script to analyze numcodr format data
# This script reads a numcodr JSON file and performs basic gender analysis

library(jsonlite)
library(dplyr)
library(tidyr)
library(ggplot2)

# Source the numcodr loader
source("numcodr-loader.R")

# Load the data using the numcodr loader
data_path <- "example-dataset.numcodr.json"
numcodr_data <- numcodr_to_dataframes(data_path)

# Extract the data frames with safety checks
demographics <- if(!is.null(numcodr_data$demographics)) numcodr_data$demographics else data.frame()
vitals <- if(!is.null(numcodr_data$vital_signs)) numcodr_data$vital_signs else data.frame()
laboratory <- if(!is.null(numcodr_data$laboratory)) numcodr_data$laboratory else data.frame()

# Check if we have data before proceeding
if(nrow(demographics) > 0) {
  # Basic gender analysis
  print("Gender distribution in the dataset:")
  gender_counts <- table(demographics$gender)
  print(gender_counts)

  print("\nAge statistics by gender:")
  age_stats <- demographics %>% 
    group_by(gender) %>%
    summarize(
      count = n(),
      mean_age = mean(age, na.rm = TRUE),
      median_age = median(age, na.rm = TRUE),
      min_age = min(age, na.rm = TRUE),
      max_age = max(age, na.rm = TRUE)
    )
  print(age_stats)

  # Analyze vital signs by gender if we have vitals data
  if(nrow(vitals) > 0) {
    print("\nBaseline vital signs by gender:")
    baseline_vitals <- vitals %>%
      filter(visit_type == "Baseline") %>%
      left_join(demographics %>% select(patient_id, gender), by = "patient_id") %>%
      group_by(gender) %>%
      summarize(
        count = n(),
        mean_hr = mean(heart_rate, na.rm = TRUE),
        mean_sbp = mean(blood_pressure_systolic, na.rm = TRUE),
        mean_dbp = mean(blood_pressure_diastolic, na.rm = TRUE),
        mean_spo2 = mean(oxygen_saturation, na.rm = TRUE)
      )
    print(baseline_vitals)
  } else {
    print("\nNo vital signs data available.")
  }

  # Create a plot of age distribution by gender
  if(length(unique(demographics$gender)) > 1) {
    p <- ggplot(demographics, aes(x = gender, y = age, fill = gender)) +
      geom_boxplot() +
      labs(title = "Age Distribution by Gender",
           x = "Gender",
           y = "Age (years)") +
      theme_minimal()

    print(p)

    # Check if BMI differs by gender if BMI column exists
    if("bmi" %in% colnames(demographics)) {
      bmi_test <- t.test(bmi ~ gender, data = demographics)
      cat("\nBMI comparison by gender:\n")
      print(bmi_test)
    } else {
      cat("\nBMI data not available for comparison.\n")
    }
  } else {
    cat("\nNot enough gender diversity for comparison plots.\n")
  }

  # Print dataset summary
  cat("\nDataset Summary:\n")
  cat("Number of patients:", length(unique(demographics$patient_id)), "\n")
  cat("Number of visits:", if(nrow(vitals) > 0) nrow(vitals) else "Unknown", "\n")
  cat("Available data frames:", paste(names(numcodr_data), collapse = ", "), "\n")
} else {
  cat("No demographic data available. Cannot proceed with analysis.\n")
}