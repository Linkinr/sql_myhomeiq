SELECT * FROM home_shopper_imports
         where import_type = 0
-- WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)
ORDER BY id DESC
LIMIT 100


