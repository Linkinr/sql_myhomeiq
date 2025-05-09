select 
sum((counters->>'prev_monthly_leads_personal_count')::int) as total_prev_monthly_leads,
sum((counters->>'leads_personal_count')::int) as leads_personal_count
from customer_details
where user_id in (
  select partner_id
  from partnerships
  where owner_id = 2 and status = 1
);
