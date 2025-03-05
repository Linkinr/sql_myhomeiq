SELECT
    SUM((counters->>'requests')::INTEGER) AS total_requests,
    SUM((counters->>'digest_sent')::INTEGER) AS total_digest_sent,
    SUM((counters->>'emails_open')::INTEGER) AS total_emails_open,
    SUM((counters->>'digest_views')::INTEGER) AS total_digest_views
from leads l
inner join lead_memberships m on l.id = m.lead_id
where m.user_id = 56579
    and
 l.lead_type in (0, 1);