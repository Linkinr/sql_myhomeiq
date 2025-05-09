select 
sum((reports_stats->>'total_digest_views')::int) as total_digest_views,
sum((reports_stats->>'total_requests')::int) as total_requests,
sum((reports_stats->>'total_digest_views')::int + (reports_stats->>'total_requests')::int) as total_interactions 
from customer_details
where user_id in (
  select partner_id
  from partnerships
  where owner_id = 2 and status = 1
);