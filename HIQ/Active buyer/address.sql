SELECT
  id,
  CONCAT(street, ', ', city, ', ', state, ' ', zip) AS address,
  unit,
  home_shopper, home_shopper_active
FROM properties
WHERE
    home_shopper_active IS TRUE



