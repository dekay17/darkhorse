-- check if hunt completed
select
(SELECT count(*) from hunt_photo hp where hp.hunt_id = 2) - (select count(*) from photo_found pf, hunt_photo hp where hp.photo_id = pf.photo_id and pf.account_id = 1003 and hp.hunt_id = 2)
= 0

-- rebuild hunt points table
insert into hunt_points(hunt_id, account_id, points, completed)
select hunt_id, pf.account_id, sum(points), false from photo_found pf, hunt_photo h, photo p 
where h.photo_id = pf.photo_id and pf.photo_id = p.photo_id
group by hunt_id, pf.account_id