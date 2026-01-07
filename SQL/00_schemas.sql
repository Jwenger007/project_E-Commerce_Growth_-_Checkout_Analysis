-- Purpose:
-- Create database schemas to separate raw source data
-- from cleaned, analysis-ready tables.
--
-- raw   : original data loaded from CSV files (no transformations)
-- clean : transformed tables used for analytics and business insights


CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS clean;