select * from reservations r
join users u on u.id = r.payable_id
 WHERE  (applications & 16) > 0 -- realtor_premium is ON
  AND (applications & 128) = 0
and r.status = 2
and u.role = 0

