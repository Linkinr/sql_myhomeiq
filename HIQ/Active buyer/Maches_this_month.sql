SELECT SUM(matched)
FROM home_shopper_imports
WHERE import_type = 0
  AND created_at >= DATE_TRUNC('month', CURRENT_DATE)
