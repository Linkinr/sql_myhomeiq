WITH actual_in_progress_count AS (
    -- 1. Підрахунок ОБ'ЄКТІВ: 'printing' АБО 'en_route', згруповано за campaign_id
    SELECT
        r.campaign_id,
        COUNT(*) AS actual_count
    FROM recipients r,
         jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE (status_item ->> 'status') IN ('printing', 'en_route')
    AND refunded IS FALSE
    GROUP BY r.campaign_id
),
actual_scheduled_count AS (
    -- 2. Підрахунок ОБ'ЄКТІВ: 'scheduled', згруповано за campaign_id
    SELECT
        r.campaign_id,
        COUNT(*) AS scheduled_count
    FROM recipients r,
         jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE (status_item ->> 'status') = 'scheduled'
    AND status != 3
    GROUP BY r.campaign_id
),
actual_delivered_count AS (
    -- 3. Підрахунок ОБ'ЄКТІВ: 'delivered', згруповано за campaign_id
    SELECT
        r.campaign_id,
        COUNT(*) AS delivered_count
    FROM recipients r,
         jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE (status_item ->> 'status') = 'delivered'
    GROUP BY r.campaign_id
),
actual_not_delivered_count AS (
    -- 4. Підрахунок ОБ'ЄКТІВ: 'returned', 'redirected', 'delivery_issue', згруповано за campaign_id
    SELECT
        r.campaign_id,
        COUNT(*) AS not_delivered_count
    FROM recipients r,
         jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE (status_item ->> 'status') IN ('returned', 'redirected', 'delivery_issue')
    GROUP BY r.campaign_id
),
actual_total_recipients AS (
    -- 5. Підрахунок ЗАПИСІВ: Загальна кількість одержувачів, де delivery_statuses не порожній масив
    SELECT
        campaign_id,
        COUNT(*) AS total_recipients_count
    FROM recipients
    WHERE jsonb_array_length(delivery_statuses) > 0 -- УМОВА: delivery_statuses != '[]'
--     AND refunded IS FALSE
    AND status != 3
    GROUP BY campaign_id
    HAVING COUNT(*) > 0
)
SELECT
    c.id AS campaign_id,

    act_rec.total_recipients_count AS actual_total_recipients,
    (c.counters ->> 'total_recipients')::int AS expected_total_recipients,
    (act_rec.total_recipients_count = (c.counters ->> 'total_recipients')::int) AS is_total_recipients_match,

    COALESCE(act_prg.actual_count, 0) AS actual_in_progress_count,
    (c.counters ->> 'total_in_progress')::int AS expected_in_progress,
    (COALESCE(act_prg.actual_count, 0) = (c.counters ->> 'total_in_progress')::int) AS is_in_progress_match,

    COALESCE(act_sch.scheduled_count, 0) AS actual_scheduled_count,
    (c.counters ->> 'total_scheduled')::int AS expected_scheduled,
    (COALESCE(act_sch.scheduled_count, 0) = (c.counters ->> 'total_scheduled')::int) AS is_scheduled_match,

    COALESCE(act_del.delivered_count, 0) AS actual_delivered_count,
    (c.counters ->> 'total_delivered')::int AS expected_delivered,
    (COALESCE(act_del.delivered_count, 0) = (c.counters ->> 'total_delivered')::int) AS is_delivered_match,

    COALESCE(act_ndl.not_delivered_count, 0) AS actual_not_delivered_count,
    (c.counters ->> 'total_not_delivered')::int AS expected_not_delivered,
    (COALESCE(act_ndl.not_delivered_count, 0) = (c.counters ->> 'total_not_delivered')::int) AS is_not_delivered_match

FROM
    campaigns c
INNER JOIN actual_total_recipients act_rec ON c.id = act_rec.campaign_id
LEFT JOIN actual_in_progress_count act_prg ON c.id = act_prg.campaign_id
LEFT JOIN actual_scheduled_count act_sch ON c.id = act_sch.campaign_id
LEFT JOIN actual_delivered_count act_del ON c.id = act_del.campaign_id
LEFT JOIN actual_not_delivered_count act_ndl ON c.id = act_ndl.campaign_id;