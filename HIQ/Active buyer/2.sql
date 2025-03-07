SELECT COUNT(*)
FROM properties p
WHERE p.normalized_address_hash IN (
    SELECT normalized_address_hash
    FROM properties
    GROUP BY normalized_address_hash
    HAVING
        SUM(CASE WHEN home_shopper_active = true THEN 1 ELSE 0 END) > 0
        AND
        SUM(CASE WHEN home_shopper_active = false THEN 1 ELSE 0 END) > 0
);
