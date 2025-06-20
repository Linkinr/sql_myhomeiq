SELECT
  -- Останні 30 днів
  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'requests') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
  ) AS requests_last_30_days,

  -- Попередні 30 днів
  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'requests') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '60 days'
      AND (elem->>'date')::date < current_date - INTERVAL '30 days'
  ) AS requests_prev_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'digest_sent') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
  ) AS digest_sent_last_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'digest_sent') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '60 days'
      AND (elem->>'date')::date < current_date - INTERVAL '30 days'
  ) AS digest_sent_prev_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'emails_open') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
  ) AS emails_open_last_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'emails_open') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '60 days'
      AND (elem->>'date')::date < current_date - INTERVAL '30 days'
  ) AS emails_open_prev_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'digest_views') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
  ) AS digest_views_last_30_days,

  (
    SELECT COALESCE(SUM((elem->>'counter')::int), 0)
    FROM jsonb_array_elements(reports_stats->'digest_views') AS elem
    WHERE (elem->>'date')::date >= current_date - INTERVAL '60 days'
      AND (elem->>'date')::date < current_date - INTERVAL '30 days'
  ) AS digest_views_prev_30_days,

  -- Відсоток відкриттів за останні 30 днів
  (
    SELECT 
      CASE 
        WHEN digest_sent = 0 THEN 0
        ELSE ROUND((emails_open::numeric / digest_sent) * 100, 2)
      END
    FROM (
      SELECT
        COALESCE(SUM((elem->>'counter')::int), 0) AS emails_open,
        (
          SELECT COALESCE(SUM((sub->>'counter')::int), 0)
          FROM jsonb_array_elements(reports_stats->'digest_sent') AS sub
          WHERE (sub->>'date')::date >= current_date - INTERVAL '30 days'
        ) AS digest_sent
      FROM jsonb_array_elements(reports_stats->'emails_open') AS elem
      WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
    ) AS rate_calc
  ) AS open_rate_last_30_days,

  -- Відсоток відкриттів за попередні 30 днів
  (
    SELECT 
      CASE 
        WHEN digest_sent = 0 THEN 0
        ELSE ROUND((emails_open::numeric / digest_sent) * 100, 2)
      END
    FROM (
      SELECT
        COALESCE(SUM((elem->>'counter')::int), 0) AS emails_open,
        (
          SELECT COALESCE(SUM((sub->>'counter')::int), 0)
          FROM jsonb_array_elements(reports_stats->'digest_sent') AS sub
          WHERE (sub->>'date')::date >= current_date - INTERVAL '60 days'
            AND (sub->>'date')::date < current_date - INTERVAL '30 days'
        ) AS digest_sent
      FROM jsonb_array_elements(reports_stats->'emails_open') AS elem
      WHERE (elem->>'date')::date >= current_date - INTERVAL '60 days'
        AND (elem->>'date')::date < current_date - INTERVAL '30 days'
    ) AS rate_calc
  ) AS open_rate_prev_30_days,

  -- Сума requests + digest_views за останні 30 днів
  (
    (
      SELECT COALESCE(SUM((elem->>'counter')::int), 0)
      FROM jsonb_array_elements(reports_stats->'requests') AS elem
      WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
    ) +
    (
      SELECT COALESCE(SUM((elem->>'counter')::int), 0)
      FROM jsonb_array_elements(reports_stats->'digest_views') AS elem
      WHERE (elem->>'date')::date >= current_date - INTERVAL '30 days'
    )
  ) AS interactions_last_30_days

FROM customer_details
WHERE user_id =20983
