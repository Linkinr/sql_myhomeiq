WITH digest_data AS (
  SELECT 
    (elem->>'counter')::int AS counter,
    (elem->>'date')::date AS date
  FROM customer_details,
  LATERAL jsonb_array_elements(reports_stats->'digest_sent') AS elem
  WHERE user_id = 22819
),
emails_open_data AS (
  SELECT 
    (elem->>'counter')::int AS counter,
    (elem->>'date')::date AS date
  FROM customer_details,
  LATERAL jsonb_array_elements(reports_stats->'emails_open') AS elem
  WHERE user_id = 20983
)
SELECT
  -- digest_sent
  SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '30 days' THEN counter ELSE 0 END) AS last_30_days_digest_sent,
  SUM(CASE 
        WHEN date >= CURRENT_DATE - INTERVAL '60 days' 
         AND date < CURRENT_DATE - INTERVAL '30 days' 
      THEN counter ELSE 0 
  END) AS prev_30_days_digest_sent,
  SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '30 days' THEN counter ELSE 0 END) -
  SUM(CASE 
        WHEN date >= CURRENT_DATE - INTERVAL '60 days' 
         AND date < CURRENT_DATE - INTERVAL '30 days' 
  THEN counter ELSE 0 END) AS digest_sent_difference,

  -- emails_open
  (SELECT SUM(counter) FROM emails_open_data WHERE date >= CURRENT_DATE - INTERVAL '30 days') AS last_30_days_emails_open,

  -- open rate percentage
  ROUND(
    (
      (SELECT SUM(counter) FROM emails_open_data WHERE date >= CURRENT_DATE - INTERVAL '30 days')::decimal /
      NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '30 days' THEN counter ELSE 0 END), 0)
    ) * 100, 2
  ) AS open_rate_percentage

FROM digest_data;
