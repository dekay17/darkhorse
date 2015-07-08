CREATE OR REPLACE FUNCTION update_hunt_points(in_account_id bigint)
  RETURNS bigint AS $$
BEGIN
	delete from hunt_points where account_id = in_account_id;

	insert into hunt_points(hunt_id, account_id, points, completed) 
		select hunt_id, pf.account_id, sum(points), false from photo_found pf, hunt_photo h, photo p 
		where h.photo_id = pf.photo_id and pf.photo_id = p.photo_id and pf.account_id = in_account_id 
		group by hunt_id, pf.account_id;
	
	return sum(points) from hunt_points where account_id = in_account_id;
END;
$$ LANGUAGE plpgsql;