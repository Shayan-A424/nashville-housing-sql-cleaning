# Nashville Housing Data Cleaning (PostgreSQL)

This project cleans and standardizes the Nashville Housing dataset using **PostgreSQL** and **pgAdmin 4**.  
It focuses on common data-cleaning tasks like standardizing dates, filling missing values, splitting columns, and normalizing categorical fields.

---

## Tools Used
- PostgreSQL
- pgAdmin 4

---

## Dataset
This dataset comes from a guided tutorial and is shared by the original author.

- Source: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx
- Note: The dataset file is not included in this repository. Please download it from the source link above.

---

## What This Script Does
The SQL script performs the following cleaning steps:

1. **Standardize Sale Date**
   - Adds `sale_date_converted` (DATE)
   - Converts raw `sale_date` text into a proper date format

2. **Populate Missing Property Addresses**
   - Uses a self-join on `parcel_id`
   - Fills NULL `property_address` values using another row with the same `parcel_id`

3. **Split Property Address into Columns**
   - Creates `property_split_address` and `property_address_city`
   - Splits the original property address into address + city

4. **Split Owner Address into Columns**
   - Creates `owner_split_address`, `owner_split_city`, and `owner_split_state`
   - Splits the original owner address into address + city + state

5. **Normalize SoldAsVacant**
   - Converts `Y` → `Yes`
   - Converts `N` → `No`

6. **Drop Unused Columns**
   - Drops raw columns after cleaned columns are created

---

## How to Run
1. Import the dataset into PostgreSQL as a table named **`nashville_housing_raw`**.
2. Open and run: `sql/nashville_housing_cleaning.sql` in pgAdmin Query Tool.
3. Execute the script from top to bottom.

---

## Screenshots

### 1) Query Output 1
![SQLSS1](screenshots/SQLSS1.PNG)

### 2) Query Output 2
![SQLSS2](screenshots/SQLSS2.PNG)

### 3) Query Output 3
![SQLSS3](screenshots/SQLSS3.PNG)

### 4) Query Output 4
![SQLSS4](screenshots/SQLSS4.PNG)

---

## Files
- `sql/nashville_housing_cleaning.sql` — main cleaning script

