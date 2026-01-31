-- =======================================================================
-- PATIENT FLAGS TABLE
-- =======================================================================
-- Summary table of all patients with key demographic information, 
-- survival status, flag for prostate cancer, and primary organization 
-- assignment.
-- =======================================================================

DROP TABLE IF EXISTS patient_flags;
CREATE TABLE patient_flags as
WITH recent_org as (
	SELECT DISTINCT ON (e.patient)
		e.patient as patient_id,
		e.organization,
		o.name,
		o.city,
		o.state,
		o.zip,
		o.lat,
		o.lon
	FROM encounters as e
	LEFT JOIN organizations as o
	ON e.organization = o.id
	ORDER BY e.patient, e.start DESC
)
SELECT 
	p.id as patient_id,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE,p.birthdate)) as age,
	p.gender,
	p.race,
	p.ethnicity,
	p.income,
	ro.organization,
	ro.name as org_name,
	ro.city as org_city,
	ro.state as org_state,
	ro.zip as org_zip,
	ro.lat as org_lat,
	ro.lon as org_lon,
	CASE WHEN p.deathdate IS NULL THEN 1
		 ELSE 0 END as is_alive,
	CASE WHEN pca.patient IS NOT NULL THEN 1 
		 ELSE 0 END as has_prostate_ca
FROM patients as p
LEFT JOIN (
	SELECT DISTINCT patient 
	FROM conditions
	WHERE code IN ('126906006','92691004','94503003')
) as pca
ON p.id = pca.patient
LEFT JOIN recent_org as ro
ON p.id = ro.patient_id;


-- Analytical summary of patient_flags table

SELECT 
    COUNT(*) as total_pts,
    SUM(is_alive) as living_pts,
    SUM(has_prostate_ca) as prostate_ca_pts,
	SUM(CASE WHEN is_alive = 1 AND has_prostate_ca = 1 THEN 1 
			 ELSE 0 END) as living_prostate_ca_pts,
    COUNT(DISTINCT organization) as unique_hospitals,
	(SELECT org_name
	 FROM patient_flags
	 GROUP BY org_name
	 ORDER BY count(*) DESC
	 LIMIT 1) as most_common_hospital
FROM patient_flags;	