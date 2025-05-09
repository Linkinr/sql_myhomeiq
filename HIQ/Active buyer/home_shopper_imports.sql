SELECT * FROM home_shopper_imports
WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)
ORDER BY id DESC
LIMIT 10

