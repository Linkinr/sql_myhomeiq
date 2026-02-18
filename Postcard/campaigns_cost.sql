SELECT * FROM campaigns
WHERE status IN (1,2)
AND cost < 1;

--Beta version
WITH per_recipient AS (
  SELECT
    r.campaign_id,
    CASE
      WHEN r.status IN (1, 2, 4) AND o.payment_type = 0 THEN 12 * r.unit_cost
        WHEN r.status IN (1, 2, 4) AND o.payment_type = 2 THEN  r.unit_cost * postcard_sequence_index
        WHEN r.status IN (1, 2, 4) AND o.payment_type = 1 THEN  r.unit_cost * 3
--       WHEN r.status = 3 and r.refunded is false THEN r.unit_cost* r.postcard_sequence_index
        WHEN r.status = 3 and r.refunded is true THEN r.unit_cost* r.postcard_sequence_index
      ELSE 0
    END AS recipient_cost,
    c.cost::numeric(12,2) AS campaign_cost
  FROM recipients r
  FULL OUTER join orders o
    ON o.id = r.order_id
  JOIN campaigns c
    ON c.id = r.campaign_id
--   WHERE c.id = 59
    WHERE c.status in (1,2)
),
agg AS (
  SELECT
    campaign_id,
    SUM(recipient_cost)::numeric(12,2) AS total_unit_cost,
    campaign_cost
  FROM per_recipient
  GROUP BY campaign_id, campaign_cost
)
SELECT
  campaign_id,
  total_unit_cost,
  campaign_cost,
  CASE
    WHEN total_unit_cost > campaign_cost THEN 'greater'
    WHEN total_unit_cost = campaign_cost THEN 'equal'
    ELSE 'less'
  END AS comparison_result
FROM agg;