# Clinical Trial Feasibility Analysis - Prostate Cancer

A comprehensive data analytics portfolio project demonstrating clinical trial feasibility workflows used in pharmaceutical and biotechnology companies. This analysis evaluates patient recruitment potential for Abbott's non-metastatic prostate cancer trial using synthetic electronic health record (EHR) data.

NOTE: Project is still a work in progress. PowerBi dashboard pending.

## Business Problem
Pharmaceutical companies invest millions in clinical trials, with patient recruitment being one of the most significant challenges. Before launching a trial, sponsors must answer critical questions:

- How many eligible patients exist in a given population?
- What percentage of patients will screen fail due to inclusion/exclusion criteria?
- Which criteria are most restrictive?
- What is the realistic recruitment timeline?

## Project Overview
- **Therapeutic Area:** Non-metastatic prostate cancer
- **Trial Protocol:** Study of Atrasentan in Men With Non-Metastatic, Hormone-Refractory Prostate Cancer (NCT00036556 | Sponsor: Abbott Laboratories) 
- **Dataset:** Over 5,000 synthetic patients (Synthea<sup>1</sup>), 28 living prostate cancer patients
- **Tools:** PostgreSQL, SQL, Power BI, pgAdmin4
- **Key Finding:** 0% recruitment feasibility due to prior treatment with chemotherapy for all patients living prostate cancer patients who had received hormone therapy. This may suggest that this disease is rather aggresive in its onset/clincal treatment plan or a high prevelance of late stage diagnoses within our dataset. Next steps would be to expand patient population pool via looking into expanding to other healthcare sites or brainstorm with clinical teams ways to reach earlier stage prostate cancer patients.

## Data Limitations & Assumptions

- **PSA values:** Not available in synthetic data; documented as key limitation requiring additional data sources
- **Performance status:** ECOG scores not captured; would require chart review in real-world implementation
- **Medication indications:** As synthetic data did not always offer reasons why certain medications were taken assumptions had to be made for opioid use and raditaion treatment
- **Temporal precision:** Some criteria require clinical judgment beyond structured data fields. This analysis should always be followed with confirmation and review by clinical staff since trial eligibility is often determined on a case-by-case basis.

## Skills Demonstrated
- Complex SQL queries for patient cohort identification
- Multi-table joins and data modeling
- Healthcare terminology (SNOMED CT codes)
- Inclusion/exclusion criteria logic
- Data visualization and executive reporting
- Clinical domain expertise and analytical thinking
- Data quality awareness and identifying limitations posed by synthetic EHR data for trial feasibility

## Resources
- ClinicalTrials.gov: https://clinicaltrials.gov/study/NCT00036556?term=NCT00036556&rank=1
- Synthea: https://synthea.mitre.org/

## Citations
1. Jason Walonoski, Mark Kramer, Joseph Nichols, Andre Quina, Chris Moesel, Dylan Hall, Carlton Duffett, Kudakwashe Dube, Thomas Gallagher, Scott McLachlan, Synthea: An approach, method, and software mechanism for generating synthetic patients and the synthetic electronic health care record, Journal of the American Medical Informatics Association, Volume 25, Issue 3, March 2018, Pages 230–238, https://doi.org/10.1093/jamia/ocx079
