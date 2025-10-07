select * from leads l
left join lead_memberships m on l.id = m.lead_id
and l.user_id = m.user_id
where m.id is null;