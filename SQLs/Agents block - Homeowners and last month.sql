select counters ->> 'leads_personal_count' as Homeowners, counters ->> 'prev_monthly_leads_personal_count' as last_month from customer_details
where user_id in (select partner_id from partnerships
where owner_id = 2 and status = 1)
order by counters ->> 'leads_personal_count' desc