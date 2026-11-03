

-- Create a separate schema for unmodified source data.
-- dbt will later transform this data into relational models.

CREATE SCHEMA IF NOT EXISTS raw;
  