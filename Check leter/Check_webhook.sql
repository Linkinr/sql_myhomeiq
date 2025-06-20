select u.id, u.name, c.* from callback_api_keys c
         join users u on  c.user_id = u.id
where code = 5
AND trim(c.settings ->> 'last_request_body') != '{}'

