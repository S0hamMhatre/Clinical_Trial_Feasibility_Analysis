-- =======================================================================
-- SCHEMA SETUP
-- Clinical Trial Eligibility Analysis Database
-- =======================================================================
-- This script creates the base database structure.
-- In order to reproduce this analysis raw synthea CSV files should be 
-- loaded into these tables prior to running any subsequent scripts.
--
-- Author: Soham Mhatre
-- Date: January 2026
-- =======================================================================

-- Patients Table
DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
    id VARCHAR(100) PRIMARY KEY,
    birthdate DATE,
    deathdate DATE,
    ssn VARCHAR(20),
    drivers VARCHAR(50),
    passport VARCHAR(50),
    prefix VARCHAR(10),
    first VARCHAR(50),
    middle VARCHAR(50),
    last VARCHAR(50),
    suffix VARCHAR(10),
    maiden VARCHAR(50),
    marital VARCHAR(20),
    race VARCHAR(50),
    ethnicity VARCHAR(50),
    gender VARCHAR(20),
    birthplace VARCHAR(200),
    address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    county VARCHAR(100),
    fips VARCHAR(10),
    zip VARCHAR(10),
    lat NUMERIC(10, 6),
    lon NUMERIC(10, 6),
    healthcare_expenses NUMERIC(12, 2),
    healthcare_coverage NUMERIC(12, 2),
    income INTEGER
);

-- Conditions Table (Diagnoses)
DROP TABLE IF EXISTS conditions;
CREATE TABLE conditions (
    start DATE,
    stop DATE,
    patient VARCHAR(100) REFERENCES patients(id),
    encounter VARCHAR(100),
    system VARCHAR(200),
    code VARCHAR(50),
    description TEXT
);

-- Medications Table
DROP TABLE IF EXISTS medications;
CREATE TABLE medications (
    start DATE,
    stop DATE,
    patient VARCHAR(100) REFERENCES patients(id),
    payer VARCHAR(100),
    encounter VARCHAR(100),
    code VARCHAR(50),
    description TEXT,
    base_cost NUMERIC(10, 2),
    payer_coverage NUMERIC(10, 2),
    dispenses INTEGER,
    totalcost NUMERIC(10, 2),
    reasoncode VARCHAR(50),
    reasondescription TEXT
);

-- Procedures Table
DROP TABLE IF EXISTS procedures;
CREATE TABLE procedures (
    start DATE,
    stop DATE,
    patient VARCHAR(100) REFERENCES patients(id),
    encounter VARCHAR(100),
    system VARCHAR(200),
    code VARCHAR(50),
    description TEXT,
    base_cost NUMERIC(10, 2),
    reasoncode VARCHAR(50),
    reasondescription TEXT
);

-- Encounters Table
DROP TABLE IF EXISTS encounters;
CREATE TABLE encounters (
    id VARCHAR(100) PRIMARY KEY,
    start TIMESTAMP,
    stop TIMESTAMP,
    patient VARCHAR(100) REFERENCES patients(id),
    organization VARCHAR(100),
    provider VARCHAR(100),
    payer VARCHAR(100),
    encounterclass VARCHAR(50),
    code VARCHAR(50),
    description TEXT,
    base_encounter_cost NUMERIC(10, 2),
    total_claim_cost NUMERIC(10, 2),
    payer_coverage NUMERIC(10, 2),
    reasoncode VARCHAR(50),
    reasondescription TEXT
);

-- Organizations Table
DROP TABLE IF EXISTS organizations;
CREATE TABLE organizations (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(200),
    address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(10),
    lat NUMERIC(10, 6),
    lon NUMERIC(10, 6),
    phone VARCHAR(50),
    revenue NUMERIC(15, 2),
    utilization INTEGER
);


-- Validation Query

SELECT 'patients' as table_name, COUNT(*) as record_count FROM patients
UNION ALL
SELECT 'conditions', COUNT(*) FROM conditions
UNION ALL
SELECT 'medications', COUNT(*) FROM medications
UNION ALL
SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL
SELECT 'encounters', COUNT(*) FROM encounters
UNION ALL
SELECT 'organizations', COUNT(*) FROM organizations;