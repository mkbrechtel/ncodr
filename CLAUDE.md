# NCODR Project Summary

## Overview
NCODR is a data harmonization framework for clinical research data in the NUKLEUS project. It converts hierarchical JSON data into flat R dataframes for analysis.

## Key Data Structure

```
ncodr.json
|
├── meta                           # Metadata about the dataset
|   ├── id                         # Unique dataset identifier
|   ├── datetime                   # Creation timestamp
|   ├── study_id                   # Study identifier
|   ├── version                    # Format version
|   ├── transformations[]          # List of data transformations
|   |   ├── name                   # Transformation name
|   |   ├── version                # Transformation version
|   |   ├── datetime               # When transformation occurred
|   |   └── parameters             # Transformation parameters
|   |
|   └── sources[]                  # Data sources
|       ├── id                     # Source identifier
|       ├── type                   # Source type
|       ├── datetime               # Source timestamp
|       └── description            # Source description
|
└── patients                       # Patient data dictionary
    └── {patient_id}               # Patient identifier as key
        └── visits                 # Patient visits dictionary
            └── {visit_id}         # Visit identifier as key (e.g. "Baseline_1")
                ├── demographics    # Patient demographic data
                ├── vital_signs     # Vital measurements
                ├── laboratory      # Lab test results
                ├── samples         # Biological samples
                ├── covid_status    # COVID-specific information
                ├── comorbidities   # Pre-existing conditions
                └── ...            # Other clinical data categories
```

## Key Components

1. **ncodr-loader.R**: Transforms nested JSON into flat dataframes
   - `ncodr_to_dataframes()`: Main function to convert JSON to dataframes
   - `flatten_nested_data()`: Helper to handle nested structures

2. **Data Transformation Flow**:
   - Source systems → source-unmapped.ncodr.json
   - Pseudonymization → source.ncodr.json
   - Multiple sources → unified.ncodr.json
   - Bioprobes/images to visit mapping → snapped.ncodr.json
   - JSON → Data frames (R and Pandas)

3. **Example Scripts**:
   - `display.R`: Shows the structure of converted dataframes
   - `analysis.R`: Performs basic gender-stratified analysis

## Current Status
The project is under active development. API changes may occur without notice.

## Study Example
The example dataset contains COVID-19 patient data with:
- 4 patients with varying demographics
- Multiple visit types (Baseline, Follow-Up, Outcome)
- Clinical assessments, vital signs, and laboratory results
- Disease progression and outcomes tracking