
-- Analysis: Product Categories
-- Purpose:
-- Identify differences in customer satisfaction across
-- product categories to detect operational issues and opportunities.
-- Note:
-- Read-only analysis queries only.


SELECT
    cp.product_category,
    COUNT(*) AS orders,
    ROUND(AVG(oe.avg_review_score), 2) AS avg_review_score
FROM raw.order_items oi
JOIN clean.products cp
    ON oi.product_id = cp.product_id
JOIN clean.orders_experience oe
    ON oi.order_id = oe.order_id
WHERE oe.avg_review_score IS NOT NULL
GROUP BY cp.product_category
ORDER BY avg_review_score ASC;