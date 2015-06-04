insert into account(account_id, email, name, password, remember_me_token)
values(1, 'dan@kelleyland.com', 'dkelley', 'abc123', 'abc123');

--                 { place_id: "1", name: "ODU", description: "My House", 
--                 image_url: "https://s3.amazonaws.com/lv-place-logos/ODU_sm.jpg",
--                 proximity_description: "200 miles", hunt_count: 2, latitude: 36.885976, longitude: -75.193638 },
insert into place(place_id, image_file_name, name, description, latitude, longitude)
values(1,'photo.jpg', 'ODU', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 36.885992, -76.304939);

insert into place(place_id, image_file_name, name, description, latitude, longitude)
values(2,'Penn-Logo_sm.jpg', 'U Penn', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 39.952240, -75.193638);

insert into place(place_id, image_file_name, name, description, latitude, longitude)
values(3,'photo.jpg', 'Ole Miss', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 34.364745, -89.538770);

-- South Ithan
-- 40.030866, -75.345704

-- ODU
-- 36.885992, -76.304939

-- Ole Miss
-- 34.364781, -89.538722

-- { "hunt_id": "1", "name": "Where is Ben?", "description": "My House", 
-- "image_url": "https://s3.amazonaws.com/lavahound-hunts/WhereIsBen/BenFranklinHead_sm.jpg",
-- "proximity_description": "247 yds", "found_count": 1, "total_count": 9 },
insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(1,1,'WhereIsBen/BenFranklinHead_sm.jpg', 'ODU Hunt', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 34.364745, -89.538770, 20);

insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(2,2,'WhereIsBen/BenFranklinHead_sm.jpg', 'Where is Ben?', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 34.364745, -89.538770, 20);

insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(3,2,'WhereIsBen/BenFranklinHead_sm.jpg', 'Penn Hunt?', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 34.364745, -89.538770, 20);

insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(4,3,'WhereIsBen/BenFranklinHead_sm.jpg', 'Ole Miss?', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 34.364745, -89.538770, 20);


-- 
insert into photo(photo_id, account_id, image_file_name, title, description, points, latitude, longitude)
values(1,1,'photo.jpg', 'Ben Franklin - Craftsman', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 10, 39.949831, -75.192803);

insert into photo(photo_id, account_id, image_file_name, title, description, points, latitude, longitude)
values(2,1,'photo.jpg', 'Ben Franklin - 2', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 10, 39.949831, -75.192803);


insert into hunt_photo(photo_id, hunt_id) values(1,2);
insert into hunt_photo(photo_id, hunt_id) values(2,2);
