select id from realtors
where duplicate_uid = (
	select duplicate_uid from realtors
	where id = 19501299
	)