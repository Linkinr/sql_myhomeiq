SELECT home_shopper, owner_occupied
FROM properties
WHERE jsonb_array_length(home_shopper->'hs_history') > 0
  AND (
    home_shopper->'hs_history'->-1->>'owner_occupied'
  )::boolean = false
and owner_occupied is true
