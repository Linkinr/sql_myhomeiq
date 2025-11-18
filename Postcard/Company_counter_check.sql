WITH actual_in_progress_count AS (
    -- 1. Підрахунок ОБ'ЄКТІВ: 'printing' АБО 'en_route' (для total_in_progress)
    SELECT COUNT(*) AS actual_count
    FROM recipients r, jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE r.campaign_id = 821 AND ((status_item ->> 'status') = 'printing' OR (status_item ->> 'status') = 'en_route')
),
actual_scheduled_count AS (
    -- 2. Підрахунок ОБ'ЄКТІВ: 'scheduled' (для total_scheduled)
    SELECT COUNT(*) AS scheduled_count
    FROM recipients r, jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE r.campaign_id = 821 AND (status_item ->> 'status') = 'scheduled'
),
actual_delivered_count AS (
    -- 3. Підрахунок ОБ'ЄКТІВ: 'delivered' (для total_delivered)
    SELECT COUNT(*) AS delivered_count
    FROM recipients r, jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE r.campaign_id = 821 AND (status_item ->> 'status') = 'delivered'
),
actual_not_delivered_count AS (
    -- 4. Підрахунок ОБ'ЄКТІВ: 'returned', 'redirected', 'delivery_issue' (для total_not_delivered)
    SELECT COUNT(*) AS not_delivered_count
    FROM recipients r, jsonb_array_elements(r.delivery_statuses) AS status_item
    WHERE r.campaign_id = 821 AND ((status_item ->> 'status') = 'returned' OR (status_item ->> 'status') = 'redirected' OR (status_item ->> 'status') = 'delivery_issue')
),
actual_total_recipients AS (
    -- 5. Підрахунок ЗАПИСІВ: Загальна кількість одержувачів у кампанії (для total_recipients)
    SELECT COUNT(*) AS total_recipients_count
    FROM recipients
    WHERE campaign_id = 821
)
SELECT
    -- Лічильник 1: total_delivered
    act_del.delivered_count AS delivered_actual_count,
    (c.counters ->> 'total_delivered')::int AS delivered_expected_count,
    (act_del.delivered_count = (c.counters ->> 'total_delivered')::int) AS delivered_result,

    -- Лічильник 2: total_scheduled
    act_sch.scheduled_count AS scheduled_actual_count,
    (c.counters ->> 'total_scheduled')::int AS scheduled_expected_count,
    (act_sch.scheduled_count = (c.counters ->> 'total_scheduled')::int) AS scheduled_result,

    -- Лічильник 3: total_recipients
    act_rec.total_recipients_count AS recipients_actual_count,
    (c.counters ->> 'total_recipients')::int AS recipients_expected_count,
    (act_rec.total_recipients_count = (c.counters ->> 'total_recipients')::int) AS recipients_result,

    -- Лічильник 4: total_in_progress
    act_prg.actual_count AS in_progress_actual_count,
    (c.counters ->> 'total_in_progress')::int AS in_progress_expected_count,
    (act_prg.actual_count = (c.counters ->> 'total_in_progress')::int) AS in_progress_result,

    -- Лічильник 5: total_not_delivered
    act_ndl.not_delivered_count AS not_delivered_actual_count,
    (c.counters ->> 'total_not_delivered')::int AS not_delivered_expected_count,
    (act_ndl.not_delivered_count = (c.counters ->> 'total_not_delivered')::int) AS not_delivered_result

FROM
    campaigns c, actual_in_progress_count act_prg, actual_scheduled_count act_sch,
    actual_delivered_count act_del, actual_not_delivered_count act_ndl, actual_total_recipients act_rec
WHERE c.id = 821;