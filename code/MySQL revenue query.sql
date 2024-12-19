SET sql_mode = '';
SELECT DISTINCT
    p.purchase_id,
    p.student_id,
    CASE
        WHEN p.subscription_type = 0 THEN 'monthly'
        WHEN p.subscription_type = 2 THEN 'annual'
        WHEN p.subscription_type = 3 THEN 'lifetime'
    END AS subscription_type,
    p.refund_id,
    p.refunded_date,
    MIN(p.purchase_date) AS first_purchase_date,
    p.purchase_date AS current_purchase_date,
    p.price,
    CASE
        WHEN MIN(p.purchase_date) = p.purchase_date THEN 'new'
        ELSE 'recurring'
    END AS revenue_type,
    CASE
        WHEN p.refunded_date IS NULL THEN 'revenue'
        ELSE 'refund'
    END AS refunds,
    s.student_country
FROM
    purchases p
INNER JOIN
    students s USING (student_id)
GROUP BY
    p.purchase_id, p.student_id, p.subscription_type, p.refund_id, p.refunded_date, p.purchase_date, p.price, s.student_country
ORDER BY
    p.purchase_date;
