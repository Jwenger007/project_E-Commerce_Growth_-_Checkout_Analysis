-- Analysis: Customer Experience
-- Purpose:
-- Evaluate the impact of delivery performance on customer
-- satisfaction using review scores.
--0= not delayed
--1= delayed
-- Note:
-- Read-only analysis queries only.


SELECT
    is_delayed,
    COUNT(*) AS orders,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM clean.orders_experience
WHERE avg_review_score IS NOT NULL
GROUP BY is_delayed;