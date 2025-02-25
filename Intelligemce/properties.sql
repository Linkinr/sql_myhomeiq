select * from properties
where city ilike 'PLYMOUTH'
and zip_code = '02360'
and street_address ilike '%60 STANDISH AVE%'
limit 5