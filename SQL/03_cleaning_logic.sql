-- Purpose:
-- Apply business logic and transformations to raw data,
-- such as revenue aggregation, delivery performance metrics,
-- and order-level KPIs used for growth and checkout analysis.


CREATE TABLE clean.order_revenue AS
SELECT
    oi.order_id,
    SUM(oi.price) AS order_revenue,
    SUM(oi.freight_value) AS order_freight_value,
    COUNT(*) AS items_count
FROM raw.order_items oi
GROUP BY oi.order_id;


CREATE TABLE clean.orders_revenue AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.delivery_days,
    o.is_delayed,

    r.order_revenue,
    r.order_freight_value,
    r.items_count

FROM clean.orders o
LEFT JOIN clean.order_revenue r
    ON o.order_id = r.order_id;



-- Aggregate payment information to order level
CREATE TABLE clean.order_payments AS
SELECT
    op.order_id,

    -- Total amount paid for the order
    SUM(op.payment_value) AS total_payment_value,

    -- Number of payment records (proxy for payment complexity)
    COUNT(*) AS payment_count,

    -- Main payment type used in the order
    MIN(op.payment_type) AS primary_payment_type,

    -- Average number of installments
    AVG(op.payment_installments) AS avg_installments

FROM raw.order_payments op
GROUP BY op.order_id;


CREATE TABLE clean.orders_checkout AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.delivery_days,
    o.is_delayed,

    r.order_revenue,
    r.items_count,

    p.total_payment_value,
    p.primary_payment_type,
    p.avg_installments

FROM clean.orders o
LEFT JOIN clean.orders_revenue r
    ON o.order_id = r.order_id
LEFT JOIN clean.order_payments p
    ON o.order_id = p.order_id;

SELECT
    primary_payment_type,
    COUNT(*) AS orders,
    ROUND(AVG(order_revenue), 2) AS avg_order_value,
    ROUND(AVG(avg_installments), 2) AS avg_installments
FROM clean.orders_checkout
WHERE primary_payment_type IS NOT NULL
GROUP BY primary_payment_type
ORDER BY orders DESC;

-- Aggregate review information to order level
CREATE TABLE clean.order_reviews AS
SELECT
    r.order_id,

    -- Average review score per order (1–5)
    AVG(r.review_score) AS avg_review_score,

    -- Number of review records per order (data quality check)
    COUNT(*) AS review_count

FROM raw.order_reviews r
GROUP BY r.order_id;

-- Combine delivery, revenue, checkout, and review data
CREATE TABLE clean.orders_experience AS
SELECT
    oc.order_id,
    oc.order_purchase_timestamp,
    oc.delivery_days,
    oc.is_delayed,

    oc.order_revenue,
    oc.items_count,
    oc.primary_payment_type,

    rv.avg_review_score,
    rv.review_count

FROM clean.orders_checkout oc
LEFT JOIN clean.order_reviews rv
    ON oc.order_id = rv.order_id;

SELECT
    is_delayed,
    COUNT(*) AS orders,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM clean.orders_experience
WHERE avg_review_score IS NOT NULL
GROUP BY is_delayed;

-- Enrich products with English category names
CREATE TABLE clean.products AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, p.product_category_name) 
        AS product_category
FROM raw.products p
LEFT JOIN raw.product_category_translation t
    ON p.product_category_name = t.product_category_name;


-- Calculate revenue per product category
CREATE TABLE clean.category_revenue AS
SELECT
    cp.product_category,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.price) AS category_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM raw.order_items oi
JOIN clean.products cp
    ON oi.product_id = cp.product_id
JOIN clean.orders o
    ON oi.order_id = o.order_id
GROUP BY cp.product_category;

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