-- Removing existing schemas for idempotency 
DROP SCHEMA IF EXISTS marts CASCADE;
DROP SCHEMA IF EXISTS warehouse CASCADE;
DROP SCHEMA IF EXISTS raw CASCADE;

-- Raw CSV data
CREATE SCHEMA raw;

-- Clean dimensional warehouse tables
CREATE SCHEMA warehouse;

-- Business reporting tables and views
CREATE SCHEMA marts;

-- Validate Schema 
SELECT '=== Validating Schema Creation ===' AS info;
SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'warehouse', 'marts')
ORDER BY schema_name;
