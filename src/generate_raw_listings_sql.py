# pandas reads the 90 CSV column names and generates SQL


from pathlib import Path
import pandas as pd

# Locate the project files.
PROJECT_ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = PROJECT_ROOT / "dataset" / "listings.csv"
SQL_PATH = PROJECT_ROOT / "sql" / "07_create_raw_listings.sql"

# Read only the CSV header.
columns = pd.read_csv(CSV_PATH, nrows=0).columns.tolist()

print(f"Number of columns: {len(columns)}")

# Validate column names.
if not columns or any(not col.strip() for col in columns):
    raise ValueError("Missing or empty column names")

if len(columns) != len(set(columns)):
    raise ValueError("Duplicate column names")

# Safely quote PostgreSQL column names.
def quote_identifier(name: str) -> str:
    return '"' + name.replace('"', '""') + '"'

# Generate one TEXT column per CSV column.
column_definitions = ",\n".join(
    f"    {quote_identifier(col)} TEXT"
    for col in columns
)

sql = f"""-- Preserve all original listings.csv columns.
-- Data cleaning and type conversions will be performed in dbt.

CREATE TABLE IF NOT EXISTS raw.listings (
{column_definitions}
);
"""

# Save the generated SQL script.
SQL_PATH.write_text(sql, encoding="utf-8")

print(f"Generated SQL: {SQL_PATH}")
