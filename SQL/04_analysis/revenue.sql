-- Analysis: Revenue
-- Purpose:
-- Analyze revenue development and order volume over time
-- to understand overall business growth.
--
-- Note:
-- Read-only analysis queries only.

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    SUM(order_revenue) AS revenue
FROM clean.orders_revenue
GROUP BY month
ORDER BY month;
