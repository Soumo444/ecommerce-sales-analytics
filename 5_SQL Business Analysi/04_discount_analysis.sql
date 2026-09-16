-- =====================================================================
-- ADVANCED DISCOUNT & PROMOTION IMPACT ANALYSIS
-- =====================================================================

-- 1. OVERALL DISCOUNT IMPACT SUMMARY
-- Compares total orders, gross revenue, discount given, and net revenue between orders with and without discounts.
SELECT 
    "Discount Availed", 
    COUNT(TID) AS Total_Orders,
    ROUND(SUM("Gross Amount"), 2) AS Total_Gross_Revenue,
    ROUND(SUM("Discount Amount (INR)"), 2) AS Total_Discounts_Given,
    ROUND(SUM("Net Amount"), 2) AS Total_Net_Revenue,
    ROUND(AVG("Net Amount"), 2) AS Average_Order_Value,
    ROUND(SUM("Net Amount") * 100.0 / (SELECT SUM("Net Amount") FROM ecommerce), 2) AS Revenue_Contribution_Percentage
FROM ecommerce
GROUP BY "Discount Availed";


-- 2. PERFORMANCE BY SPECIFIC DISCOUNT NAME / CAMPAIGN
-- Evaluates which individual promotional campaigns or discount types drive the highest volume and net revenue.
SELECT 
    "Discount Name",
    COUNT(TID) AS Orders_Count,
    ROUND(SUM("Discount Amount (INR)"), 2) AS Total_Discount_Value,
    ROUND(SUM("Net Amount"), 2) AS Total_Net_Revenue,
    ROUND(AVG("Net Amount"), 2) AS Average_Order_Value
FROM ecommerce
WHERE "Discount Availed" = 'Yes' OR "Discount Availed" = '1' -- Adjust based on your boolean value format (e.g., 'Yes' or True)
GROUP BY "Discount Name"
ORDER BY Total_Net_Revenue DESC;


-- 3. PRODUCT CATEGORY SENSITIVITY TO DISCOUNTS
-- Identifies which product categories rely most heavily on discounts to sell.
SELECT 
    "Product Category",
    COUNT(TID) AS Total_Orders,
    SUM(CASE WHEN "Discount Availed" IN ('Yes', '1', 'True') THEN 1 ELSE 0 END) AS Discounted_Orders,
    ROUND(SUM(CASE WHEN "Discount Availed" IN ('Yes', '1', 'True') THEN 1 ELSE 0 END) * 100.0 / COUNT(TID), 2) AS Discount_Dependency_Percentage,
    ROUND(SUM("Discount Amount (INR)"), 2) AS Total_Category_Discounts
FROM ecommerce
GROUP BY "Product Category"
ORDER BY Discount_Dependency_Percentage DESC;


-- 4. AVERAGE ORDER VALUE (AOV) COMPARISON: DISCOUNTED VS NON-DISCOUNTED
-- Determines if offering discounts successfully incentivizes larger basket sizes (higher gross/net order values).
SELECT 
    "Discount Availed",
    ROUND(AVG("Gross Amount"), 2) AS Avg_Gross_Amount,
    ROUND(AVG("Discount Amount (INR)"), 2) AS Avg_Discount_Amount,
    ROUND(AVG("Net Amount"), 2) AS Avg_Net_Amount
FROM ecommerce
GROUP BY "Discount Availed";