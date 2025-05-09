SELECT users.* FROM users INNER JOIN reservations ON reservations.status = 2 
AND reservations.payable_type = 'User' AND reservations.payable_id = users.id 
INNER JOIN customer_details ON customer_details.user_id = users.id WHERE users.role = 1
AND users.status = 0 AND reservations.plan_name IN ('starter_plan', 'professional_plan', 'partner_plan', 'lender_monthly_plan', 'growth_plan')
AND (customer_details.email_settings ->> 'monthly_digest' = 'true')
AND (customer_details.monthly_digest_sent_date IS NULL AND reservations.setup_subscription_at <= '2025-03-07 12:00:00' 
OR customer_details.monthly_digest_sent_date IS NOT NULL AND customer_details.monthly_digest_sent_date <= '2025-07-07')