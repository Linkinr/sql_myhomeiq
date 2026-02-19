SELECT
  u.id,
  u.name,
  CASE u.role
    WHEN 0 THEN 'Agent'
    WHEN 1 THEN 'Lender'
    ELSE u.role::text
  END AS role,
  SUM(COALESCE((t.details->>'credits_total_count')::int, 0)) AS credits_count
FROM transactions t
JOIN reservations r ON t.reservation_id = r.id
JOIN users u ON r.payable_id = u.id
WHERE t.description = 'myhomeIQ Credits'
GROUP BY
  u.id,
  u.name,
  CASE u.role
    WHEN 0 THEN 'Agent'
    WHEN 1 THEN 'Lender'
    ELSE u.role::text
  END
ORDER BY credits_count DESC
LIMIT 400;

