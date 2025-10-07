
WITH relevant_realtors AS (SELECT id
                           FROM realtors
                           WHERE duplicate_uid IN (SELECT duplicate_uid
                                                   FROM realtors
                                                   WHERE id = 216098 -- Replace 24 with your desired ID
                           ))
SELECT p.street_address, p.city, p.state, p.zip_code, s.sale_date as Closed, l.name as Loan_Officer, l.company_name, s.sale_price as PURCHASE_PRICE, s.loan_amount

FROM sales s
left join properties p on s.property_id = p.id
left join loan_officers l on s.loan_officer_id = l.id
WHERE (buyer_agent_id IN (SELECT id FROM relevant_realtors)
    OR buyer_co_agent_id IN (SELECT id FROM relevant_realtors)
    OR listing_agent_id IN (SELECT id FROM relevant_realtors)
    OR listing_co_agent_id IN (SELECT id FROM relevant_realtors))
  AND deleted IS false
  AND duplicate IS false
  AND sale_date >= '2020-08-01'


