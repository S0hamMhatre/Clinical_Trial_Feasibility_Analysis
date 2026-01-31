-- =======================================================================
-- ELIGIBILITY TABLE
-- =======================================================================
-- Assesses clinical trial eligibility for living non-metastatic 
-- prostate cancer patients based on study inclusion/exclusion criteria.
--
-- Study Title: Study of Atrasentan in Men With Non-Metastatic, 
--              Hormone-Refractory Prostate Cancer
--
-- NCT#: NCT00036556
--
-- Inclusion Criteria:
--   - Prostate cancer diagnosis
--   - On hormone therapy or post-surgical castration
--   - Male, 19+ y.o.
--
-- Exclusion Criteria:
--   - Metastatic disease
--   - Prior cytotoxic chemotherapy
--   - Recent opioid/narcotic use for CA related pain (last 6 months)
--   - Recent radiation therapy for CA related pain (last 6 months)
--
-- Output: eligibility table (28 living prostate CA patients)
--
-- Note: Prior EDA query confirmed none of the living prostate CA 
-- patients have metastatic disease therefore that exclusion criteria 
-- will be omitted from this table. 
-- =======================================================================

DROP TABLE IF EXISTS eligibility;
CREATE TABLE eligibility AS 
WITH 
-- base cohort
living_prostate_pts AS (
	SELECT * 
	FROM patient_flags 
	WHERE is_alive = 1 AND has_prostate_ca = 1
),
-- clinical context
diagnosis_info AS (
	SELECT 
		patient,
		MIN(start) as first_diagnosed_date,
		STRING_AGG(code, ', ') as codes, 
		STRING_AGG(description, ', ') as descriptions
	FROM conditions
	WHERE code IN ('126906006','92691004','94503003')
	GROUP BY patient
),
-- IC: hormone therapy. NOTE: unable to check rising PSA values 
-- while on hormone therapy as that data is not included in 
-- this data set. As a substitute this will flag if patient has 
-- ever been on hormone therapy and request further 
-- investigation from clinical team.
on_hormone_tx AS (
	SELECT distinct patient_id
	FROM patient_meds
	WHERE med_category = 'hormone'
),
-- EC: chemotherapy hx
had_chemo_tx AS (
	SELECT distinct patient_id
	FROM patient_meds
	WHERE med_category = 'chemo'
),
-- EC: Opioid/narcotic in last 6 months
recent_opioids AS (
	SELECT distinct patient_id
	FROM patient_meds
	WHERE med_category = 'opioid'
	  AND (med_stop_date IS NULL or med_stop_date >= CURRENT_DATE - INTERVAL '6 months') 
),
-- EC: Radiation Tx in the last 6 months. NOTE: unable to confirm if
-- this tx was done for pain management of prostate CA, so this flag 
-- may not fully exclude patients from the study.
recent_rad_tx AS (
	SELECT DISTINCT patient
    FROM procedures
    WHERE description ILIKE '%rad%'
      AND (stop IS NULL or stop >= CURRENT_DATE - INTERVAL '6 months')
)

SELECT 
	lpp.patient_id,
	di.codes,
	di.descriptions,
	di.first_diagnosed_date,
	CASE WHEN lpp.patient_id IN (SELECT * FROM on_hormone_tx) 
		 THEN 1 ELSE 0 END AS ic_hormone_tx,
	CASE WHEN lpp.patient_id IN (SELECT * FROM had_chemo_tx) 
		 THEN 1 ELSE 0 END AS ec_chemo_tx,
	CASE WHEN lpp.patient_id IN (SELECT * FROM recent_opioids) 
		 THEN 1 ELSE 0 END AS ec_opioids,
	CASE WHEN lpp.patient_id IN (SELECT * FROM recent_rad_tx) 
		 THEN 1 ELSE 0 END AS ec_rad_tx
FROM living_prostate_pts as lpp
LEFT JOIN diagnosis_info as di
ON lpp.patient_id = di.patient;

-- Validation: Eligibility funnel
SELECT 
    COUNT(*) AS total_living_prostate_patients,
    SUM(ic_hormone_tx) AS meets_inclusion,
    SUM(ec_chemo_tx) AS excluded_chemotherapy,
    SUM(ec_opioids) AS excluded_opioids,
    SUM(ec_rad_tx) AS excluded_radiation,
    SUM(CASE WHEN ic_hormone_tx = 1 
             AND ec_chemo_tx = 0 
             AND ec_opioids = 0 
             AND ec_rad_tx = 0 
        THEN 1 ELSE 0 END) AS final_eligible
FROM eligibility;