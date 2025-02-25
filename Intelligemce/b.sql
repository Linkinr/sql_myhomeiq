select p.street_address from sales s
join properties p on s.property_id = p.id
-- where sale_price = 560000
-- and  city ilike  'SEABROOK'

where s.id in (6827837,
24210831

)