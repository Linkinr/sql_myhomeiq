
WITH relevant_realtors AS (SELECT id
                           FROM realtors
                           WHERE duplicate_uid IN (SELECT duplicate_uid
                                                   FROM realtors
                                                   WHERE id = 918296 -- Replace 24 with your desired ID
                           ))
SELECT *
FROM sales
WHERE (buyer_agent_id IN (SELECT id FROM relevant_realtors)
    OR buyer_co_agent_id IN (SELECT id FROM relevant_realtors)
    OR listing_agent_id IN (SELECT id FROM relevant_realtors)
    OR listing_co_agent_id IN (SELECT id FROM relevant_realtors))
  AND deleted IS false
  AND duplicate IS false
  AND sale_date >= '2024-02-01'


