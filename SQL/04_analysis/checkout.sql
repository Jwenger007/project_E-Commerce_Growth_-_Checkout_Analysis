
-- Analysis: Checkout & Payment Methods
-- Purpose:
-- Analyze the impact of payment methods and installments
-- on order value and checkout performance.
-- Note:
-- This file contains read-only analysis queries.


SELECT
    primary_payment_type,
    COUNT(*) AS orders,
    ROUND(AVG(order_revenue), 2) AS avg_order_value,
    ROUND(AVG(avg_installments), 2) AS avg_installments
FROM clean.orders_checkout
GROUP BY primary_payment_type
ORDER BY orders DESC;