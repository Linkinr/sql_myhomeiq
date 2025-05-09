select * from customer_details
where user_id in (select partner_id from partnerships
where owner_id = 12093 and status = 1)