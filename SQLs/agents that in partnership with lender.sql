select * from public.customer_details
where  user_id in (select partner_id from partnerships
where owner_id = 22819 and status = 1)
