select data->'contacts'->'current_owners'
from skip_trace_loans
where loan_officers_ids = '["OTIzNzEuMTc3MDczNDc3MQ"]'
and jsonb_array_length(
            COALESCE(data->'contacts'->'current_owners', '[]'::jsonb)
          ) > 0;

SELECT
  RIGHT(u.stripe_customer_id, 5) AS id,
  COUNT(*) AS enriched,
  COUNT(*) FILTER (
    WHERE jsonb_array_length(
            COALESCE(sl.data->'contacts'->'current_owners', '[]'::jsonb)
          ) > 0
  ) AS current_owners_count
FROM skip_trace_loans sl
CROSS JOIN LATERAL jsonb_array_elements_text(sl.loan_officers_ids::jsonb) AS lo(id)
JOIN users u ON u.external_id = lo.id
GROUP BY
  lo.id,
  u.id,
  u.stripe_customer_id
ORDER BY enriched DESC;

select *
from transactions
where user_id = 9757;

SELECT
    u.name,
  RIGHT(u.stripe_customer_id, 5) AS id,
  COUNT(*) AS enriched,
  COUNT(*) FILTER (
    WHERE jsonb_array_length(
            COALESCE(sl.data->'contacts'->'current_owners', '[]'::jsonb)
          ) > 0
  ) AS current_owners_count
FROM skip_trace_sales sl
CROSS JOIN LATERAL jsonb_array_elements_text(sl.realtors_uids::jsonb) AS lo(id)
JOIN users u ON u.external_id = lo.id
GROUP BY
  lo.id,
  u.id,
  u.stripe_customer_id
ORDER BY enriched DESC;



