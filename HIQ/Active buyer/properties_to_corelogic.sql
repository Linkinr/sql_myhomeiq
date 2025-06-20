SELECT properties.*
FROM properties
         INNER JOIN (SELECT MIN(properties.id) AS id
                     FROM properties
                              INNER JOIN leads ON leads.property_id = properties.id
                              INNER JOIN users ON users.id = leads.user_id
                              INNER JOIN reservations ON reservations.status = 2 AND
                                                         reservations.payable_type = 'User' AND
                                                         reservations.payable_id = users.id
                     WHERE ((properties.home_shopper_sync_date IS NULL OR
                             properties.home_shopper_sync_date NOT BETWEEN '2025-05-01' AND '2025-05-31'))
                       AND leads.lead_status = 0
                       AND leads.lead_type IN (0, 1)
                       AND leads.report_subscribed = TRUE
                       AND users.status = 0
                       AND ((leads.seller_digest ->> 'digest_not_delivered_at') IS NULL
                         AND (leads.seller_digest ->> 'last_sent_digest_at') IS NOT NULL)
                       AND (renter_occupied_date IS NULL OR renter_occupied_date < '2024-11-07 08:28:27.937400')
                       AND properties.owner_occupied = TRUE
                       AND (users.role = 1 AND reservations.plan_name IN
                                               ('lender_limited_plan', 'professional_plan', 'corporate_title_company',
                                                'enterprise_plan', 'lender_monthly_plan', 'growth_plan', 'partner_plan')
                         OR users.role = 0 AND
                            (reservations.plan_name = 'connected_plan' AND reservations.applications & 16 > 0))
                     GROUP BY properties.normalized_address_hash) AS min_property_ids
                    ON properties.id = min_property_ids.id
ORDER BY home_shopper_sync_date IS NULL DESC,
         CASE WHEN home_shopper_sync_date IS NULL THEN created_at END DESC, properties.home_shopper_sync_date ASC