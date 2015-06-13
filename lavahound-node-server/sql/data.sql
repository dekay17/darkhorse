insert into account(account_id, email, name, password, remember_me_token)
values(1, 'dan@kelleyland.com', 'dkelley', '7288edd0fc3ffcbe93a0cf06e3568e28521687bc', '7288edd0fc3ffcbe93a0cf06e3568e28521687bc');

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
insert into photo(photo_id, account_id, image_file_name, title, description, found_msg, points, latitude, longitude)
values(1,1,'photo.jpg', 'Ben Franklin - Craftsman', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 'You found it', 10, 39.949831, -75.192803);

insert into photo(photo_id, account_id, image_file_name, title, description, found_msg, points, latitude, longitude)
values(2,1,'photo.jpg', 'Ben Franklin - 2', 'Ben Franklin was a leading author, printer, postmaster, scientist, musician, inventor, satirist, statesman, and diplomat.', 'You found it', 10, 39.949831, -75.192803);


insert into hunt_photo(photo_id, hunt_id) values(1,2);
insert into hunt_photo(photo_id, hunt_id) values(2,2);


-- load photos from excel
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'EasternStatePenn.jpg','Eastern State','Eastern State penitentiary is the home of the asylum in the movie Twelve Monkeys. It is also featured in Transformers 2. ','Al Capone, featured in The Untouchables, was once an inmate here.', 10, 39.967365, -75.172827);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'RockyStatue.jpg','Rocky Statue','Rocky won the Oscar for Best Picture in 1986. There are no statues of Thunderlips, George Washington Duke, or Clubber Lang.','Rocky was filmed on a budget of less than $1 million.', 10, 39.965041, -75.179338);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'ArtMuseumSteps.jpg','Rocky Steps','There are 72 Rocky Steps. The steps appear in every film except Rocky IV.','Challenge: Rocky ran up the steps in 10.2 seconds. See if you can beat his time.', 10, 39.964938, -75.180148);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'StAugustine.jpg','St. Augustine','Haunted Cole, played by Haley Joel Osment, attempts to seek refuge in St. Augustine''s church in The Sixth Sense.','Beware of men who wear all black lerking around.', 10, 39.955527, -75.146646);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'CityHall.jpg','City Hall','City Hall is featured in Philadelphia, Twelve Monkeys, Transformers: Revenge of the Fallen, and a variety of other films.','City Hall can be seen in the background of the final scene in Rocky.', 10, 39.952443, -75.164828);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'UnionLeague.jpg','Union League','The Union League stars as the "Heritage Club" in the movie Trading Places. Go long on frozen concentrated orange juice and pork bellies. ','Look out for Clarence Beeks selling false crop reports.', 10, 39.949930, -75.164315);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'30thStreetStation.jpg','30th Street Station','Witness was filmed at 30th Street Station. In the film, a young Amish boy witnesses a murder here and is protected by Harrison Ford.','In Trading Places, Winthorpe and Valentine depart for NYC here.', 10, 39.955673, -75.181465);