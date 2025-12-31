/*
Nashville Housing Data Cleaning (PostgreSQL)
Author: Shayan Ahmed

Dataset Source:
https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx

How to use:
1) Ensure you have a table named `nashville_housing_raw` already imported in PostgreSQL.
2) Run this script top-to-bottom in pgAdmin Query Tool.

Overview of cleaning:
- Standardize sale date into a proper DATE column
- Populate missing property addresses using a self-join on parcel_id
- Split property_address into address + city columns
- Split owner_address into address + city + state columns
- Normalize sold_as_vacant from Y/N to Yes/No
- Drop unused columns after creating cleaned versions
*/


-- =========================================================
-- 1) Standardizing Date Format
-- =========================================================

ALTER TABLE nashville_housing_raw
ADD COLUMN sale_date_converted DATE;

UPDATE nashville_housing_raw
SET sale_date_converted = to_date(sale_date, 'Month DD, YYYY');


-- =========================================================
-- 2) Populate Property Address Data (Self-Join)
--    Fill NULL property_address using matching parcel_id rows
-- =========================================================

UPDATE nashville_housing_raw a
SET property_address = COALESCE(a.property_address, b.property_address)
FROM nashville_housing_raw b
WHERE a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
  AND a.property_address IS NULL
  AND b.property_address IS NOT NULL;


-- =========================================================
-- 3) Split Property Address into Individual Columns (Address, City)
-- =========================================================

ALTER TABLE nashville_housing_raw
ADD COLUMN property_split_address VARCHAR(255);

ALTER TABLE nashville_housing_raw
ADD COLUMN property_address_city VARCHAR(255);

UPDATE nashville_housing_raw
SET property_split_address = substring(property_address FROM 1 FOR position(',' IN property_address) - 1),
    property_address_city  = trim(substring(property_address FROM position(',' IN property_address) + 1))
WHERE property_address IS NOT NULL
  AND position(',' IN property_address) > 0;


-- =========================================================
-- 4) Split Owner Address into Individual Columns (Address, City, State)
-- =========================================================

ALTER TABLE nashville_housing_raw
ADD COLUMN owner_split_address VARCHAR(255),
ADD COLUMN owner_split_city VARCHAR(255),
ADD COLUMN owner_split_state VARCHAR(255);

UPDATE nashville_housing_raw
SET owner_split_address = split_part(owner_address, ',', 1),
    owner_split_city    = trim(split_part(owner_address, ',', 2)),
    owner_split_state   = trim(split_part(owner_address, ',', 3))
WHERE owner_address IS NOT NULL;


-- =========================================================
-- 5) Normalize SoldAsVacant Values (Y/N -> Yes/No)
-- =========================================================

UPDATE nashville_housing_raw
SET sold_as_vacant = CASE
  WHEN sold_as_vacant = 'Y' THEN 'Yes'
  WHEN sold_as_vacant = 'N' THEN 'No'
  ELSE sold_as_vacant
END;


-- =========================================================
-- 6) Delete Unused Columns (run after verifying split columns)
-- =========================================================

ALTER TABLE nashville_housing_raw
  DROP COLUMN owner_address,
  DROP COLUMN tax_district,
  DROP COLUMN property_address,
  DROP COLUMN sale_date;
