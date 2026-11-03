
-- Create raw tables preserving the structure of the source CSV files.
-- Transformations will be performed later using dbt.

-- 1. Raw neighbourhoods: stores the original CSV columns.
CREATE TABLE IF NOT EXISTS raw.neighbourhoods (
    neighbourhood_group TEXT,
    neighbourhood TEXT
);


-- 2. Raw calendar: stores daily availability and stay restrictions.
CREATE TABLE IF NOT EXISTS raw.calendar (
    listing_id TEXT,
    date TEXT,
    available TEXT,
    minimum_nights TEXT,
    maximum_nights TEXT
);


-- 3. Raw reviews: stores the original review records.
CREATE TABLE IF NOT EXISTS raw.reviews (
    listing_id TEXT,
    id TEXT,
    date TEXT,
    reviewer_id TEXT,
    reviewer_name TEXT,
    comments TEXT
);
  