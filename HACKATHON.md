# Original plan for the NUKLEUS Data Harmonization Hackathon

## Overview
This focused online hackathon brings together the Epidemiology Core
Unit (ECU) and the Interaction Core Unit (ICU) to develop a unified
approach to data transformation within the NUKLEUS project. The goal
is to merge ECU's epicodr R package with ICU's Python-based data
preparation into a new framework called "numcodr".

## Background
Currently, ECU and ICU maintain separate data processing pipelines:
- ECU: epicodr (R package) for epidemiological analyses
- ICU: Python-based data preparation for billing and reporting

This divergence creates redundancies and potential inconsistencies.
The proposed solution is a standardized JSON-based format
(.numcodr.json) that supports both teams' needs.

## Goals
1. Establish a common understanding of current workflows
2. Define and validate the new .numcodr.json format with enhanced
meta-field for transformation tracking
3. Outline R package requirements for processing this format
4. Create a practical implementation plan

## Agenda
1. **Introduction & Goals** (10 min)
   - Hackathon objectives and expected outcomes
   - Brief overview of the problem statement

2. **Current Workflows** (30 min)
   - ECU Script Presentation: epicodr R package capabilities and limitations
   - Data Preparation (ICU) Presentation: Python-based processing workflow
   - Discussion of pain points and integration challenges

3. **New Data Format Proposal** (30 min)
   - Presentation of the b concept
   - Meta-field for transformation tracking
   - Organization of patient and visit data
   - Feedback and refinement discussion

4. **Implementation Planning** (45 min)
   - R package functionality requirements
   - Python interface considerations
   - Conversion paths for existing workflows
   - API design and function specifications

5. **Technical Implementation** (30 min)
   - Collaborative coding session using shared environment
   - Development of prototype functions
   - Testing with sample data
   - Documentation approach

6. **Next Steps & Assignments** (15 min)
   - Development roadmap
   - Task assignments
   - Timeline for alpha release
   - Communication plan

## Expected Outcomes
1. Working specifications for the numcodr format
2. Initial R functions for parsing .numcodr.json files
3. Conversion examples for existing datasets
4. Development roadmap with assigned responsibilities
5. Timeline for alpha release

This focused session aims to produce concrete results rather than just
discussion. By limiting attendance to only the essential teams and
providing a collaborative development environment, we will maximize
productivity during the limited time available.


# Appendix: Proposed Data Architecture

## Data Flow
1. **Import:** Source systems → source-unmapped.numcodr.json
2. **THS Mapping:** Pseudonymization → source.numcodr.json
3. **Unification:** Multiple sources → unified.numcodr.json
4. **Snapping:** Bioprobes/images to visit mapping → snapped.numcodr.json
5. **Analysis:** JSON → Data frames (R and Pandas)

## File Organization
- Standard path structure: data/$study_id/$date/*.numcodr.json
- CLI interface: `--data-folder data/ --study-id nukleus-example-study`

## Example .numcodr.json Format

```json
{
  "meta": {
    "id": "01890e12-a35c-7c21-8762-32a63511e7e3",
    "datetime": "2023-11-15T14:30:00Z",
    "study_id": "nukleus-example-study",
    "version": "1.0.0",
    "transformations": [
      {
        "name": "cdm_import",
        "version": "0.3.2",
        "datetime": "2023-11-15T13:45:22Z",
        "parameters": {"source": "secutrial_export_20231114.zip"}
      },
      {
        "name": "ths_mapping",
        "version": "1.2.0",
        "datetime": "2023-11-15T14:10:05Z",
        "parameters": {"map_file": "cdm.ths-transferids-map.json"}
      }
    ],
    "sources": [
      {
        "id": "secutrial_export_20231114.zip",
        "type": "cdm",
        "datetime": "2023-11-14T23:15:00Z",
        "description": "Daily full export from SecuTrial CDM"
      }
    ]
  },
  "patients": {
    "example_12354": {
      "visits": {
        "Baseline_1": {
          "demographics": {
            "age": 45,
            "gender": "male",
            "height": 178,
            "weight": 82,
            "bmi": 25.9,
            "education_level": "university",
            "smoking_status": "former",
            "pack_years": 12
          },
          "vital_signs": {
            "heart_rate": 72,
            "blood_pressure_systolic": 128,
            "blood_pressure_diastolic": 85,
            "temperature": 36.7,
            "oxygen_saturation": 98,
            "respiratory_rate": 14
          },
          "medications": {
            "medication_name": "Metformin",
            "dosage": "500mg",
            "frequency": "twice daily",
            "start_date": "2022-05-10",
            "indication": "Type 2 Diabetes"
          },
          "samples": {
            "blood_sample_id": "BS12345",
            "collection_time": "2023-01-15T09:30:00",
            "storage_temperature": -80,
            "volume_collected": 10,
            "processing_delay_minutes": 35,
            "centrifuged": true,
            "hemolysis": false
          },
          "comorbidities": {
            "diabetes": true,
            "diabetes_type": "T2DM",
            "diabetes_diagnosis_year": 2020,
            "hypertension": true,
            "hypertension_diagnosis_year": 2018,
            "ckd": false,
            "copd": false
          },
          "questionnaires": {
            "eq5d": {
              "mobility": 1,
              "selfcare": 1,
              "usual_activities": 2,
              "pain_discomfort": 1,
              "anxiety_depression": 2,
              "vas_score": 78
            }
          }
        },
        "Follow-Up_1": {
          "vital_signs": {
            "heart_rate": 68,
            "blood_pressure_systolic": 130,
            "blood_pressure_diastolic": 82,
            "temperature": 36.5,
            "oxygen_saturation": 99,
            "respiratory_rate": 12
          },
          "laboratory": {
            "hemoglobin": 14.0,
            "leukocytes": 7.2,
            "thrombocytes": 245,
            "crp": 0.5,
            "hba1c": 6.8,
            "cholesterol_total": 195,
            "ldl": 120,
            "hdl": 45,
            "triglycerides": 150,
            "creatinine": 0.9,
            "egfr": 85
          },
          "medications": {
            "medication_name": "Metformin",
            "dosage": "1000mg",
            "frequency": "twice daily",
            "start_date": "2023-02-05",
            "indication": "Type 2 Diabetes"
          },
          "imaging": {
            "image_id": "CT23456",
            "modality": "CT",
            "body_part": "chest",
            "contrast": true,
            "findings": "No significant abnormalities",
            "radiologist_id": "RAD123"
          }
        }
      }
    }
  }
}
```

# Results of the NUKLEUS Data Harmonization Hackathon

## Role of epicodr: Primary Coding

A key outcome of the hackathon was clarity regarding epicodr's primary role in the workflow: primary coding of study data. The ECU team explained that epicodr was specifically designed to handle the transformation of raw clinical data into standardized, analysis-ready formats. This process, known as "Primärkodierung" (primary coding), involves:

1. **Data Standardization**
   - Converting values to consistent units and formats
   - Applying common coding schemes across different study sites
   - Resolving inconsistencies in data collection

2. **Derived Variable Creation**
   - Calculating BMI from height and weight
   - Generating risk scores from multiple input variables
   - Transforming raw measurements into clinically meaningful categories

3. **Data Quality Assessment**
   - Identifying missing or implausible values
   - Flagging potential data entry errors
   - Generating quality reports for study sites

4. **Statistical Preparation**
   - Converting data into formats suitable for statistical analysis
   - Creating analysis datasets with appropriate variable selection
   - Applying necessary transformations for specific analytical methods

The hackathon team agreed that these primary coding functions should be preserved and enhanced in the new numcodr framework, ensuring that the expertise embedded in epicodr's processing logic is not lost during the integration process.

## Integration of SecuTrial Metadata

During the hackathon, the ECU team highlighted the importance of incorporating SecuTrial's metadata tables into the numcodr format. SecuTrial organizes its metadata across several key tables that can be leveraged for enhancing the numcodr workflow:

1. **Code Lists (cl)**
   - Contains all codes and labels for nominal/categorical variables
   - Essential for proper interpretation of coded values in the dataset
   - Enables consistent decoding of numeric codes to meaningful labels

2. **Visit Plan (vp)**
   - Describes the study's visit structure and timeline
   - Contains visit IDs and definitions
   - Provides the foundation for temporal organization of study data

3. **Visit Plan to Form Mapping (vps)**
   - Maps form IDs to specific visits in the visit plan
   - Defines which forms should be collected during each visit
   - Enables automated assignment of data to the correct visit context

By incorporating these SecuTrial metadata tables into the numcodr format, we can achieve:

1. **Enhanced Data Transformation**
   - Ensuring proper data typing and validation using form definitions
   - Maintaining coding schemes and value mappings from the code lists
   - Preserving the original study design intentions

2. **Automated Visit Assignment**
   - Using vp and vps tables to map forms to appropriate visit types
   - Ensuring consistent organization of data across the study timeline
   - Validating the completeness of visit data based on the expected forms

3. **Improved Data Quality**
   - Validating collected data against expected variables and formats
   - Identifying missing or out-of-range values
   - Maintaining the integrity of the original study design

The integration of these metadata tables will require careful mapping of SecuTrial's database structure to the numcodr format.

# Updated numcodr Pipeline with SecuTrial Metadata Integration

## Complete Pipeline Structure

1. **Data Import**
   - **Primary Data Import:** Source systems (SecuTrial, LIMS) → source-unmapped.numcodr.json
   - **Metadata Import:** SecuTrial metadata tables (cl, vp, vps) → metadata.numcodr.json
   - Output: source-unmapped.numcodr.json + metadata.numcodr.json

2. **THS Mapping**
   - Input: source-unmapped.numcodr.json
   - Process: Pseudonymization via ths-tools
   - Output: source.numcodr.json (with pseudonymized IDs)

3. **Visit Mapping & Metadata Integration** (NEW STEP)
   - Input: source.numcodr.json + metadata.numcodr.json
   - Process:
     - Apply visit plan structure from vp table
     - Map forms to appropriate visits using vps mappings
     - Apply code lists (cl) for categorical variables
     - Validate data against expected structure
   - Output: source-structured.numcodr.json (with proper visit structure)

4. **Unification**
   - Input: Multiple source-structured.numcodr.json files from different sources
   - Process: Merge data from multiple sources (CDM, LIMS, etc.)
   - Output: unified.numcodr.json

5. **Snapping**
   - Input: unified.numcodr.json
   - Process: Map bioprobes/images to corresponding visits
   - Output: snapped.numcodr.json

6. **Secondary Processing**
   - Input: snapped.numcodr.json
   - Process: Additional transformations based on study-specific needs
   - Output: processed.numcodr.json

7. **Data Frame Transformation**
   - Input: processed.numcodr.json
   - Process: Convert to R/Python data frames for analysis
   - Output: Study-specific data frames

# Updated numcodr Pipeline with Enhanced Snapping for Repeating Groups

## Complete Pipeline Structure

1. **Data Import**
   - **Primary Data Import:** Source systems (SecuTrial, LIMS) → source-unmapped.numcodr.json
   - **Metadata Import:** SecuTrial metadata tables (cl, vp, vps) → metadata.numcodr.json
   - Output: source-unmapped.numcodr.json + metadata.numcodr.json

2. **THS Mapping**
   - Input: source-unmapped.numcodr.json
   - Process: Pseudonymization via ths-tools
   - Output: source.numcodr.json (with pseudonymized IDs)

3. **Visit Mapping & Metadata Integration**
   - Input: source.numcodr.json + metadata.numcodr.json
   - Process:
     - Apply visit plan structure from vp table
     - Map forms to appropriate visits using vps mappings
     - Apply code lists (cl) for categorical variables
     - Validate data against expected structure
   - Output: source-structured.numcodr.json (with proper visit structure)
   - **Note:** At this stage, repeating groups without visit assignments are stored in a separate key under each patient object: `patient.repeating_items`

4. **Unification**
   - Input: Multiple source-structured.numcodr.json files from different sources
   - Process: Merge data from multiple sources (CDM, LIMS, etc.)
   - Output: unified.numcodr.json

5. **Multi-Source Snapping**
   - Input: unified.numcodr.json
   - Process: A series of specialized snapping operations:
   
     a. **Repeating Groups Snapping**
     - Target: data in `patient.repeating_items` (e.g., medication lists)
     - Process: Uses timestamps to associate items with closest visits
     - Maps items to appropriate visits or maintains as longitudinal data
     
     b. **Bioprobe Snapping**
     - Target: laboratory samples without clear visit assignment
     - Process: Maps samples to visits based on collection times
     
     c. **Image Data Snapping**
     - Target: imaging studies from different systems
     - Process: Maps imaging procedures to corresponding visits
     
     d. **Other Timestamp-based Data Snapping**
     - Target: any other data with timestamps but no direct visit association
     - Process: Apply appropriate temporal logic to assign to visits
   
   - Output: fully-snapped.numcodr.json

6. **Secondary Processing**
   - Input: fully-snapped.numcodr.json
   - Process: Additional transformations based on study-specific needs
   - Output: processed.numcodr.json

7. **Data Frame Transformation**
   - Input: processed.numcodr.json
   - Process: Convert to R/Python data frames for analysis
   - Output: Study-specific data frames

# Example Data Strategy for numcodr

You've raised excellent points about example data. Here's how we can integrate these recommendations into the numcodr project:

## Example Data Sources

- **secuTrialR Package**: Great resource for SecuTrial test data - we should leverage this in our development
- **Similar Packages**: We should identify and catalog equivalent resources for REDCap and other systems

## Implementation Strategy

1. **Test Data Integration**
   - Include standardized example datasets in the source code repository
   - Create a dedicated `test_data` directory with subdirectories for each source system
   - Structure test cases to validate each pipeline step independently

2. **Data Integration Protocol for New Systems**
   - Create a formal "Data Integration Requirements" document that specifies:
     - Example dataset requirements
     - Expected format and completeness
     - Documentation needs
   - Make this a mandatory part of onboarding new data sources

3. **Study Setup Process Enhancement**
   - Establish a protocol where eCRF verification data is automatically routed to the development team
   - Create a standardized process to convert this data into test cases
   - Document typical variations and edge cases in each study

## Enhanced Metadata Fields

Let's extend the metadata structure to include:

```json
"meta": {
  "id": "01890e12-a35c-7c21-8762-32a63511e7e3",
  "datetime": "2023-11-15T14:30:00Z",
  "study_id": "nukleus-example-study",
  "version": "1.0.0",
  "data_classification": {
    "contains_patient_data": true,
    "publishable": false,
    "synthetic_data": false,
    "consent_status": {
      "source": "THS",
      "status": "all_consented",
      "verification_date": "2023-11-14T10:00:00Z"
    }
  },
  "transformations": [
    // transformation entries as before
  ]
}
```

## Testing Framework Benefits

1. **Continuous Integration**
   - Automated tests can run on each commit/PR
   - Ensures new changes don't break existing functionality

2. **Documentation Through Examples**
   - Example data serves as living documentation
   - New developers can understand expected data structures

3. **Edge Case Coverage**
   - Collect unusual data scenarios in test cases
   - Better prepare for real-world data challenges

4. **Synthetic Data Generation**
   - Use example structures to generate larger synthetic datasets
   - Create varied test scenarios with controlled parameters
   - Produce shareable datasets for teaching and collaboration
   - Generate realistic test data without privacy concerns

5. **Validation Pipeline**
   - Create a separate pipeline that validates numcodr.json files
   - Checks against schema, expected values, etc.

This comprehensive approach to test data will save significant time in development and troubleshooting, especially as the number of supported systems grows. The ability to generate synthetic data further extends its utility for training, demonstrations, and external collaborations.
