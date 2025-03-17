# 📊 World Layoffs Data Cleaning Project  

## 📌 Overview  
This project focuses on *cleaning and transforming* the "World Layoffs" dataset using SQL. I also used *AI (DeepSeek)* to efficiently validate and correct inconsistencies in the data, improving accuracy and speed.  

### *Description*  
I cleaned a large dataset by removing duplicates, standardizing values, handling missing data, and fixing encoding errors. The final dataset is structured, accurate, and ready for analysis.   

## 📂 Files in the Repository  
- raw file.csv  
- clean data.csv  
- projectquery.sql  
- README.md  

## 🔍 Data Cleaning Process  
1️⃣ *Created a staging table* to avoid modifying the original data.  
2️⃣ *Identified duplicate records* using ROW_NUMBER() and removed them.  
3️⃣ *Standardized industry and location names* by fixing typos and formatting issues.  
4️⃣ *Fixed encoding errors* (e.g., "DÃ¼sseldorf" → "Düsseldorf").  
5️⃣ *Handled missing values* by removing rows where critical fields were empty.  
6️⃣ *Converted date fields* to a proper DATE format.  
7️⃣ *Final verification* using SQL queries to check for inconsistencies.  

## 🚀 Key SQL Techniques Used  
✅ *CTE (Common Table Expressions) & Window Functions* for duplicate detection.  
✅ *String functions (TRIM(), LIKE)* for data standardization.  
✅ *Date formatting (STR_TO_DATE())* for proper data handling.  
✅ *JOINs and Subqueries* for updating and verifying data.  

## 🏆 What I Learned  
- *Data cleaning best practices in SQL*  
- *How to automate data validation using AI (DeepSeek)*  
- *Handling encoding errors and inconsistencies in large datasets*  
- *Improved SQL querying and data transformation techniques*  

---
🔹 *Feel free to explore the project and provide feedback!* 🔹
