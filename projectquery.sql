SELECT * 
FROM world_layoffs.layoffs;
-- View the original dataset to understand its structure and content.

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;
-- Create a staging table with the same structure as the original table.

INSERT world_layoffs.layoffs_staging
SELECT *
FROM world_layoffs.layoffs; 
-- Copy all data from the original table to the staging table.

WITH temp_table AS 
(
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM world_layoffs.layoffs_staging
)
SELECT *
FROM temp_table 
WHERE row_num > 1;
-- Create a temporary table to identify duplicate rows. Duplicates are marked with `row_num > 1`.

CREATE TABLE world_layoffs.layoffs_staging2
LIKE world_layoffs.layoffs_staging;
-- Create a second staging table for further processing.

INSERT world_layoffs.layoffs_staging2
SELECT *
FROM world_layoffs.layoffs_staging;
-- Copy data from the first staging table to the second staging table.

ALTER TABLE world_layoffs.layoffs_staging2
ADD COLUMN row_num INT;
-- Add a `row_num` column to mark duplicate rows.

ALTER TABLE world_layoffs.layoffs_staging2
ADD COLUMN s_num INT AUTO_INCREMENT PRIMARY KEY;
-- Add an `s_num` column as a primary key for unique identification of rows.

UPDATE world_layoffs.layoffs_staging2 AS table_2
JOIN (
    SELECT ID,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM world_layoffs.layoffs_staging2
) AS temp_Column 
ON table_2.s_num = temp_column.s_num
SET table_2.row_num = temp_column.row_num;
-- Update the `row_num` column to mark duplicate rows.

DELETE FROM world_layoffs.layoffs_staging2  
WHERE row_num = 2;
-- Delete rows marked as duplicates (`row_num = 2`)

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN s_num;
-- Drop the `s_num` column as it is no longer needed.

ALTER TABLE world_layoffs.layoffs_staging2  
DROP COLUMN row_num;
-- Drop the `row_num` column as it is no longer needed.

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);
-- Remove extra spaces from the `company` column.

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2; 
-- Check for unique values in the `industry` column.

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- Standardize industry names by replacing variations of "Crypto" with a single value.

SELECT DISTINCT location
FROM world_layoffs.layoffs_staging2; 
-- Check for unique values in the `location` column.

-- Exported the result as a CSV file and used AI (DeepSeek) to check for spelling mistakes and inconsistencies.
-- There were some, so I updated them. This method helped automate and speed up the data validation process efficiently.
-- Spelling mistakes:
/* 
- "DÃ¼sseldorf" and "Dusseldorf" = "Düsseldorf".
- "MalmÃ¶" should be "Malmö".
- "Shenzen" should likely be "Shenzhen".
- "Ferdericton" should be "Fredericton".
- "FlorianÃ³polis" should be "Florianópolis". 
*/

UPDATE world_layoffs.layoffs_staging2
SET location = 'Düsseldorf'
WHERE location = 'DÃ¼sseldorf' OR location = 'Dusseldorf';
-- Correct the spelling of "Düsseldorf".

SELECT DISTINCT location
FROM world_layoffs.layoffs_staging2;
-- Verify that the location names were updated correctly.

UPDATE world_layoffs.layoffs_staging2
SET location = 
    CASE
        WHEN location = 'MalmÃ¶' THEN 'Malmö'
        WHEN location = 'Shenzen' THEN 'Shenzhen'
        WHEN location = 'Ferdericton' THEN 'Fredericton'
        WHEN location = 'FlorianÃ³polis' THEN 'Florianópolis'
        ELSE location
    END;
-- Correct spelling mistakes in the `location` column.

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2;
-- Check for unique values in the `country` column.

-- Sent the CSV to DeepSeek for validation.
-- DeepSeek identified one mistake: "United States." should be "United States".

UPDATE world_layoffs.layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';
-- Correct the spelling of "United States".

UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Convert the `date` column from text to a proper DATE format.

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;
-- Change the `date` column to the DATE data type.

SELECT 
    id, 
    (percentage_laid_off is null or percentage_laid_off = ' ')
    AND (total_laid_off is null or total_laid_off = ' ')
FROM world_layoffs.layoffs_staging2;
-- Check for rows where both `percentage_laid_off` and `total_laid_off` are NULL.

DELETE 
FROM world_layoffs.layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '')  
AND percentage_laid_off IS NULL;
-- Delete rows where both `total_laid_off` and `percentage_laid_off` are NULL or empty.

SELECT *
FROM world_layoffs.layoffs_staging2;
-- Final check of the cleaned dataset.