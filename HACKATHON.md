# Original plan for the NUKLEUS Data Harmonization Hackathon

## Overview
This focused online hackathon brings together the Epidemiology Core
Unit (ECU) and the Interaction Core Unit (ICU) to develop a unified
approach to data transformation within the NUKLEUS project. The goal
is to merge ECU's epicodr R package with ICU's Python-based data
preparation into a new framework called "ncodr".

## Background
Currently, ECU and ICU maintain separate data processing pipelines:
- ECU: epicodr (R package) for epidemiological analyses
- ICU: Python-based data preparation for billing and reporting

This divergence creates redundancies and potential inconsistencies.
The proposed solution is a standardized JSON-based format
(.ncodr.json) that supports both teams' needs.

## Goals
1. Establish a common understanding of current workflows
2. Define and validate the new .ncodr.json format with enhanced
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
1. Working specifications for the ncodr format
2. Initial R functions for parsing .ncodr.json files
3. Conversion examples for existing datasets
4. Development roadmap with assigned responsibilities
5. Timeline for alpha release

This focused session aims to produce concrete results rather than just
discussion. By limiting attendance to only the essential teams and
providing a collaborative development environment, we will maximize
productivity during the limited time available.


# Appendix: Proposed Data Architecture

## Data Flow
1. **Import:** Source systems → source-unmapped.ncodr.json
2. **THS Mapping:** Pseudonymization → source.ncodr.json
3. **Unification:** Multiple sources → unified.ncodr.json
4. **Snapping:** Bioprobes/images to visit mapping → snapped.ncodr.json
5. **Analysis:** JSON → Data frames (R and Pandas)

## File Organization
- Standard path structure: data/$study_id/$date/*.ncodr.json
- CLI interface: `--data-folder data/ --study-id nukleus-example-study`

## Example .ncodr.json Format

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

The hackathon team agreed that these primary coding functions should be preserved and enhanced in the new ncodr framework, ensuring that the expertise embedded in epicodr's processing logic is not lost during the integration process.

## Integration of SecuTrial Metadata

During the hackathon, the ECU team highlighted the importance of incorporating SecuTrial's metadata tables into the ncodr format. SecuTrial organizes its metadata across several key tables that can be leveraged for enhancing the ncodr workflow:

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

By incorporating these SecuTrial metadata tables into the ncodr format, we can achieve:

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

The integration of these metadata tables will require careful mapping of SecuTrial's database structure to the ncodr format.

# Updated ncodr Pipeline with SecuTrial Metadata Integration

## Complete Pipeline Structure

1. **Data Import**
   - **Primary Data Import:** Source systems (SecuTrial, LIMS) → source-unmapped.ncodr.json
   - **Metadata Import:** SecuTrial metadata tables (cl, vp, vps) → metadata.ncodr.json
   - Output: source-unmapped.ncodr.json + metadata.ncodr.json

2. **THS Mapping**
   - Input: source-unmapped.ncodr.json
   - Process: Pseudonymization via ths-tools
   - Output: source.ncodr.json (with pseudonymized IDs)

3. **Visit Mapping & Metadata Integration** (NEW STEP)
   - Input: source.ncodr.json + metadata.ncodr.json
   - Process:
     - Apply visit plan structure from vp table
     - Map forms to appropriate visits using vps mappings
     - Apply code lists (cl) for categorical variables
     - Validate data against expected structure
   - Output: source-structured.ncodr.json (with proper visit structure)

4. **Unification**
   - Input: Multiple source-structured.ncodr.json files from different sources
   - Process: Merge data from multiple sources (CDM, LIMS, etc.)
   - Output: unified.ncodr.json

5. **Snapping**
   - Input: unified.ncodr.json
   - Process: Map bioprobes/images to corresponding visits
   - Output: snapped.ncodr.json

6. **Secondary Processing**
   - Input: snapped.ncodr.json
   - Process: Additional transformations based on study-specific needs
   - Output: processed.ncodr.json

7. **Data Frame Transformation**
   - Input: processed.ncodr.json
   - Process: Convert to R/Python data frames for analysis
   - Output: Study-specific data frames

# Updated ncodr Pipeline with Enhanced Snapping for Repeating Groups

## Complete Pipeline Structure

1. **Data Import**
   - **Primary Data Import:** Source systems (SecuTrial, LIMS) → source-unmapped.ncodr.json
   - **Metadata Import:** SecuTrial metadata tables (cl, vp, vps) → metadata.ncodr.json
   - Output: source-unmapped.ncodr.json + metadata.ncodr.json

2. **THS Mapping**
   - Input: source-unmapped.ncodr.json
   - Process: Pseudonymization via ths-tools
   - Output: source.ncodr.json (with pseudonymized IDs)

3. **Visit Mapping & Metadata Integration**
   - Input: source.ncodr.json + metadata.ncodr.json
   - Process:
     - Apply visit plan structure from vp table
     - Map forms to appropriate visits using vps mappings
     - Apply code lists (cl) for categorical variables
     - Validate data against expected structure
   - Output: source-structured.ncodr.json (with proper visit structure)
   - **Note:** At this stage, repeating groups without visit assignments are stored in a separate key under each patient object: `patient.repeating_items`

4. **Unification**
   - Input: Multiple source-structured.ncodr.json files from different sources
   - Process: Merge data from multiple sources (CDM, LIMS, etc.)
   - Output: unified.ncodr.json

5. **Multi-Source Snapping**
   - Input: unified.ncodr.json
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
   
   - Output: fully-snapped.ncodr.json

6. **Secondary Processing**
   - Input: fully-snapped.ncodr.json
   - Process: Additional transformations based on study-specific needs
   - Output: processed.ncodr.json

7. **Data Frame Transformation**
   - Input: processed.ncodr.json
   - Process: Convert to R/Python data frames for analysis
   - Output: Study-specific data frames

# Example Data Strategy for ncodr

You've raised excellent points about example data. Here's how we can integrate these recommendations into the ncodr project:

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
   - Create a separate pipeline that validates ncodr.json files
   - Checks against schema, expected values, etc.

This comprehensive approach to test data will save significant time in development and troubleshooting, especially as the number of supported systems grows. The ability to generate synthetic data further extends its utility for training, demonstrations, and external collaborations.

# Date Normalization with Patient-Level t0 Field

## Enhanced Pipeline Step: Date Normalization

This step adds a standardized approach to handling relative timings in clinical studies by adding a `t0` object at the patient level.

### Updated Pipeline Position
```
... → fully-snapped.ncodr.json → DATE NORMALIZATION → t0-normalized.ncodr.json → Secondary Processing → ...
```

### Implementation Details

#### Patient-Level t0 Object
The Date Normalization step would add a `t0` object to each patient:

```json
{
  "patients": {
    "example_12354": {
      "t0": {
        "selected_baseline": "consent_date",
        "baseline_rationale": "Per study protocol",
        "available_dates": {
          "consent_date": "2022-03-15",
          "screening_date": "2022-03-18",
          "baseline_visit_date": "2022-03-25",
          "first_treatment_date": "2022-04-02"
        },
        "day_adjustments": {
          "consent_to_baseline": 10,
          "protocol_adjustment": -1
        }
      },
      "visits": {
        // Visit data as before
      }
    }
  }
}
```

#### Study-Level Metadata
The meta section would be enhanced with information about available start dates:

```json
"meta": {
  // Other metadata as before
  "date_normalization": {
    "available_baseline_types": [
      "consent_date",
      "screening_date", 
      "baseline_visit_date",
      "first_treatment_date"
    ],
    "default_baseline": "consent_date",
    "protocol_defined_timepoint": "consent_date"
  }
}
```

### Benefits of this Approach

1. **Centralized Reference Point**: The `t0` object acts as a single source of truth for all relative time calculations

2. **Multiple Baseline Options**: Preserves all potential baseline dates while clearly indicating which one was selected

3. **Adjustment Flexibility**: The `day_adjustments` field allows for protocol-specific adjustments or corrections

4. **Documentation**: Explicitly documents the rationale for baseline selection

5. **Optional Application**: Relative dates can be calculated on demand during analysis rather than requiring date transformation throughout the dataset

### Practical Implementation

1. This step would extract all relevant dates from the patient data
2. Apply configurable rules to determine the selected baseline
3. Document available dates in the `t0` object
4. Include any necessary day adjustments based on protocol specifications

This approach maintains the integrity of original absolute dates while providing a standardized framework for relative time calculations that's critical for proper analysis of longitudinal clinical data.

# Tracking eCRF Data Changes Over Time

## Challenge: Capturing Data Evolution

- Assessing documentation quality and completeness
- Audit trail requirements
- Understanding data entry patterns and timing
- Quality control processes

## Current Approaches

1. **SQL Reports on SecuTrial Database**
   - Direct database queries capture change history
   - Reports stored in separate folder with each CDM export
   - Provides comprehensive audit trail

2. **Alternative: Daily Export Analysis**
   - Extract change information from sequential exports (cdm-export-$date.zip)
   - Enables change detection without direct database access
   - Requires consistent daily export process

### Collaboration with CDM Team

This is an excellent opportunity for collaboration with the CDM team.

We might want to integrate those exports into the ncodr codebase for reproducability and version these reports, so no downstream systems are affected when the report format changes.

# Hackathon Summary

While we didn't get to coding today, we've made significant progress in several key areas:

- Defined the core data structure with patient-level organization
- Outlined a comprehensive pipeline with specialized steps
- Identified the need for proper handling of repeating groups
- Developed a strategy for relative date normalization with the t0 object
- Addressed metadata integration from SecuTrial
- Considered historical data tracking needs
- Established an example data and testing strategy

# Participant Feedback & Next Steps

## Hackathon Reflections
- While we focused primarily on conceptual design rather than coding, the brainstorming sessions proved valuable for aligning our vision
- The limited timeframe allowed us to establish a solid foundation for the project architecture
- A follow-up meeting will be scheduled to continue the momentum

## Implementation Strategy
- We will now proceed directly to implementation based on the agreed framework
- The core pipeline components will be developed primarily in Python
