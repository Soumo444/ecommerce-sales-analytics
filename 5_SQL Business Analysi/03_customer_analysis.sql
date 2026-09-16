-- =====================================================================
-- CUSTOMER RETENTION & CHURN SEGMENTATION ANALYSIS
-- =====================================================================

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