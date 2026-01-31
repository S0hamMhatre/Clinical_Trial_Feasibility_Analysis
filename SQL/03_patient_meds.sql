-- =======================================================================
-- PATIENT MEDS TABLE
-- =======================================================================
-- Creates a medications table for all prostate cancer patients with
-- medication codes, start/stop dates, and categorization flags for 
-- hormone therapy, chemotherapy, and opioid medications.
-- =======================================================================

DROP TABLE IF EXISTS patient_meds;
CREATE TABLE patient_meds AS
SELECT 
	m.patient as patient_id,
	m.code as med_code,
	m.description as med_description,
	m.reasoncode as reason_code,
	m.reasondescription as reason_description,
	m.start as med_start_date,
	m.stop as med_stop_date,
	CASE WHEN code IN ('857005', '1049625', '856987', '1735006', 
		 '856987', '1049221', '856980', '1809104', '1729584') THEN 'opioid'
		 WHEN code IN ('1860480', '1736854', '583214', '1736776') THEN 'chemo'
		 WHEN code = '752899' THEN 'hormone'
		 ELSE NULL END as med_category
FROM medications as m
WHERE m.patient IN (
	SELECT patient_id
	FROM patient_flags
	WHERE has_prostate_ca = 1
);

-- The following script identifies codes for key inclusion/exclusion 
-- criteria medications:
-- Hormone therapy: '752899' 
-- Chemo: '1860480', '1736854', '583214', '1736776'
-- Opioids: '857005', '1049625', '856987', '1735006', '856987', '1049221', 
--          '856980', '1809104', '1729584'

SELECT
	med_code,
	med_description
FROM patient_meds
WHERE med_description ILIKE '%oxycodone%' OR
	  med_description ILIKE '%leuprolide%' OR
	  med_description ILIKE '%hydrocodone%' OR
	  med_description ILIKE '%taxel%' OR
	  med_description ILIKE '%platin%' OR
	  med_description ILIKE '%fentanyl%' OR
	  med_description ILIKE '%fentanil%' OR
	  med_description ILIKE '%codeine%' OR
	  med_description ILIKE '%morphine%'
GROUP BY med_code, med_description;


-- Analytical Summary
SELECT 
    med_category,
    COUNT(DISTINCT patient_id) AS unique_patients,
    COUNT(*) AS total_prescriptions
FROM patient_meds
GROUP BY med_category
ORDER BY unique_patients DESC;