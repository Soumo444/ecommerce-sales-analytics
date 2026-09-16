-- =====================================================================
-- E-COMMERCE DATA QUALITY & INTEGRITY AUDIT SCRIPT
-- =====================================================================

-- 1. Total Record Count Audit
SELECT 
    COUNT(*) AS Total_Rows 
FROM ecommerce;


-- 2. Missing Value Check Across Key Transactional Fields
SELECT 
    SUM(CASE WHEN CID IS NULL THEN 1 ELSE 0 END) AS Missing_CID,
    SUM(CASE WHEN TID IS NULL THEN 1 ELSE 0 END) AS Missing_TID,
    SUM(CASE WHEN "Product Category" IS NULL THEN 1 ELSE 0 END) AS Missing_Product_Category,
    SUM(CASE WHEN "Gross Amount" IS NULL THEN 1 ELSE 0 END) AS Missing_Gross_Amount,
    SUM(CASE WHEN "Net Amount" IS NULL THEN 1 ELSE 0 END) AS Missing_Net_Amount,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS Missing_Location
FROM ecommerce;


-- 3. Duplicate Transaction Check (Ensures Transaction IDs are unique)
SELECT 
    TID, 
    COUNT(*) AS Duplicate_Count
FROM ecommerce
GROUP BY TID
HAVING COUNT(*) > 1;


-- 4. Financial Anomaly Check (Checking for zero or negative net amounts)
SELECT 
    COUNT(*) AS Invalid_Net_Amount_Rows
FROM ecommerce
WHERE "Net Amount" <= 0;


-- 5. Range & Distribution Check (Min, Max, and Average for Financials)
SELECT 
    MIN("Gross Amount") AS Min_Gross_Amount,
    MAX("Gross Amount") AS Max_Gross_Amount,
    ROUND(AVG("Gross Amount"), 2) AS Avg_Gross_Amount,
    MIN("Net Amount") AS Min_Net_Amount,
    MAX("Net Amount") AS Max_Net_Amount,
    ROUND(AVG("Net Amount"), 2) AS Avg_Net_Amount
FROM ecommerce;