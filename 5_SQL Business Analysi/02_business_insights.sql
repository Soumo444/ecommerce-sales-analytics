-- =====================================================================
-- E-COMMERCE BUSINESS INTELLIGENCE & ANALYTICS SQL SUITE
-- =====================================================================

-- 1. EXECUTIVE REVENUE SUMMARY
SELECT 
    COUNT(TID) AS Total_Transactions,
    ROUND(SUM("Gross Amount"), 2) AS Gross_Revenue,
    ROUND(SUM("Discount Amount (INR)"), 2) AS Total_Discounts,
    ROUND(SUM("Net Amount"), 2) AS Net_Revenue,
    ROUND(AVG("Net Amount"), 2) AS Average_Order_Value
FROM ecommerce;


-- 2. PRODUCT CATEGORY PERFORMANCE & REVENUE SHARE
SELECT 
    "Product Category",
    COUNT(TID) AS Total_Orders,
    ROUND(SUM("Net Amount"), 2) AS Category_Net_Revenue,
    ROUND(SUM("Net Amount") * 100.0 / (SELECT SUM("Net Amount") FROM ecommerce), 2) AS Revenue_Share_Percentage,
    ROUND(AVG("Net Amount"), 2) AS Category_AOV
FROM ecommerce
GROUP BY "Product Category"
ORDER BY Category_Net_Revenue DESC;


-- 3. GEOGRAPHIC PERFORMANCE (TOP 5 LOCATIONS)
SELECT 
    Location,
    COUNT(TID) AS Orders_Count,
    ROUND(SUM("Net Amount"), 2) AS Location_Revenue,
    ROUND(AVG("Net Amount"), 2) AS Location_AOV
FROM ecommerce
GROUP BY Location
ORDER BY Location_Revenue DESC
LIMIT 5;


-- 4. DISCOUNT IMPACT ANALYSIS
SELECT 
    "Discount Availed", 
    COUNT(TID) AS Orders_Count,
    ROUND(SUM("Gross Amount"), 2) AS Total_Gross,
    ROUND(SUM("Net Amount"), 2) AS Total_Net_Revenue,
    ROUND(AVG("Net Amount"), 2) AS AOV
FROM ecommerce
GROUP BY "Discount Availed";


-- 5. CUSTOMER RETENTION & CHURN SEGMENTATION
WITH CustomerOrders AS (
    SELECT 
        CID,
        COUNT(TID) AS Order_Count,
        SUM("Net Amount") AS Lifetime_Spend
    FROM ecommerce
    GROUP BY CID
),
SegmentedCustomers AS (
    SELECT 
        CID,
        Order_Count,
        Lifetime_Spend,
        CASE 
            WHEN Order_Count = 1 THEN 'One-Time / Churned'
            ELSE 'Retained / Repeat'
        END AS Customer_Status
    FROM CustomerOrders
)
SELECT 
    Customer_Status,
    COUNT(CID) AS Customer_Count,
    ROUND(COUNT(CID) * 100.0 / (SELECT COUNT(*) FROM CustomerOrders), 2) AS Percentage_Share,
    ROUND(SUM(Lifetime_Spend), 2) AS Total_Segment_Revenue,
    ROUND(AVG(Lifetime_Spend), 2) AS Average_Customer_LTV
FROM SegmentedCustomers
GROUP BY Customer_Status;