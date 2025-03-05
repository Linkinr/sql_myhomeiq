select id, concat(street, ', ', city, ', ', state, ', ', zip  ), unit, home_shopper from properties
where home_shopper_active is true;