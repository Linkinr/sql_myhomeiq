WITH PostcardSequences AS (
    -- 1. Розгортаємо всі статуси і додаємо порядковий номер/індекс
    SELECT
        r.id AS recipient_id,
        (t.status_item ->> 'status') AS current_status,
        (t.status_item ->> 'postcard_sequence_index')::int AS sequence_index,

        -- Використовуємо LAG для отримання статусу попереднього елемента
        LAG(t.status_item ->> 'status') OVER (
            PARTITION BY r.id
            ORDER BY (t.status_item ->> 'postcard_sequence_index')::int
        ) AS previous_status
    FROM
        recipients r,
        jsonb_array_elements(r.delivery_statuses) AS t(status_item)
),
StatusViolations AS (
    -- 2. Знаходимо порушення послідовності
    SELECT DISTINCT
        recipient_id
    FROM
        PostcardSequences
    WHERE
        current_status = 'delivered' -- Поточний статус "delivered"
        AND previous_status IS NOT NULL -- Не перший елемент
        AND previous_status != 'delivered' -- Попередній статус НЕ був "delivered"
)
-- 3. Вибираємо фінальні записи
SELECT
    r.* -- Вибираємо всі колонки одержувача
FROM
    recipients r
INNER JOIN StatusViolations sv ON r.id = sv.recipient_id
WHERE r.status !=3;