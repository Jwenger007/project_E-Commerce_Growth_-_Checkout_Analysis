-- Purpose:
-- Create clean, analysis-ready tables derived from raw data.
-- This layer applies basic filtering and structural transformations
-- (e.g. delivered orders only) to support reliable business analysis.


CREATE TABLE clean.orders AS
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Delivery KPIs
    DATE_PART(
        'day',
        o.order_delivered_customer_date - o.order_purchase_timestamp
    ) AS delivery_days,

    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS is_delayed

FROM raw.orders o
WHERE o.order_status = 'delivered';


