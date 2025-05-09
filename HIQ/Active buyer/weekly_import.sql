SELECT count(DISTINCT(normalized_address_hash))
FROM properties
WHERE properties.home_shopper_active = TRUE
  AND properties.home_shopper_sync_date >= DATE_TRUNC('month', CURRENT_DATE)
  AND properties.home_shopper_sync_date < DATE_TRUNC('month', CURRENT_DATE + INTERVAL '1 month');
