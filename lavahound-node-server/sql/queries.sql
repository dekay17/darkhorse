-- check if hunt completed
select
(SELECT count(*) from hunt_photo hp where hp.hunt_id = 2) - (select count(*) from photo_found pf, hunt_photo hp where hp.photo_id = pf.photo_id and pf.account_id = 1003 and hp.hunt_id = 2)
= 0

-- rebuild hunt points table
insert into hunt_points(hunt_id, account_id, points, completed)
select hunt_id, pf.account_id, sum(points), false from photo_found pf, hunt_photo h, photo p 
where h.photo_id = pf.photo_id and pf.photo_id = p.photo_id
group by hunt_id, pf.account_id

-- find rank in hunt
SELECT account_id,points, rank FROM (
  SELECT account_id,points,rank() OVER (ORDER BY points desc) FROM hunt_points where hunt_id = 
) AS ranking WHERE account_id=1001

select * from hunt

update photo set found_msg = 'Inscribed at the top of the arch is a quote from George Washington: "Naked and starving as they are. We cannot enough admire. The incomparable Patience and Fidelity of the Soldiery"'
where photo_id = 1067

update photo set found_msg = 'Did you know the chapel grounds are not part of the park? It''s just completely surrounded by Valley Forge National Historical Park'
where photo_id = 1065


-- find photos for hunt
select p.* from photo p, hunt_photo hp
where hp.photo_id = p.photo_id and hp.hunt_id = 1008