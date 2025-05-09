SELECT 
  id, 
  CONCAT(street, ', ', city, ', ', state, ', ', zip) AS address, 
  unit, 
  home_shopper
FROM properties
WHERE home_shopper_active IS TRUE
  AND (home_shopper->>'owner_occupied')::boolean = FALSE
LIMIT 230
