WITH relevant_realtors AS (
    SELECT id
    FROM realtors
    WHERE duplicate_uid IN (
        SELECT duplicate_uid
        FROM realtors
        WHERE id = 216098
    )
),
loan_deduplicated AS (
    SELECT DISTINCT ON (sale_id) *
    FROM loans
    ORDER BY sale_id, id  -- або за іншим критерієм, якщо треба
)
SELECT
    s.id,
    p.street_address,
    p.city,
    p.state,
    p.zip_code,
   lo.owner_name,
    s.sale_date AS Closed,
    l.name AS Loan_Officer,
    l.company_name,
    s.sale_price AS PURCHASE_PRICE,
    s.loan_amount,
    p.pre_mover_score / 10
FROM sales s
LEFT JOIN properties p ON s.property_id = p.id
LEFT JOIN loan_officers l ON s.loan_officer_id = l.id
LEFT JOIN loan_deduplicated lo ON s.id = lo.sale_id
WHERE (
        s.buyer_agent_id IN (SELECT id FROM relevant_realtors)
     OR buyer_co_agent_id IN (SELECT id FROM relevant_realtors)
     OR listing_agent_id IN (SELECT id FROM relevant_realtors)
     OR listing_co_agent_id IN (SELECT id FROM relevant_realtors)
)
  AND s.deleted IS false
  AND s.duplicate IS false
  AND s.sale_date >= '2020-08-01'
