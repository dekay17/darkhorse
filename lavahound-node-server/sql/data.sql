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


-- Philadelphia Hunt
insert into place(place_id, image_file_name, name, description, latitude, longitude)
values(nextval('place_id_seq'),'Philadelphia.jpg', 'Philadelphia', 'Pennsylvania’s largest city, is notable for its rich history, on display at the Liberty Bell, Independence Hall – where the Declaration of Independence and Constitution were signed – and other American Revolutionary sites.', 39.965041, -75.179338);

insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(nextval('hunt_id_seq'),currval('place_id_seq'),'RockyStatue.jpg', 'Movies', 'No less iconic are the steps of the Philadelphia Museum of Art, immortalized by Sylvester Stallone’s triumphant run in the film "Rocky."', 39.965041, -75.179338, 20);

-- load photos from excel
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'EasternStatePenn.jpg','Eastern State','Eastern State penitentiary is the home of the asylum in the movie Twelve Monkeys. It is also featured in Transformers 2. ','Al Capone, featured in The Untouchables, was once an inmate here.', 10, 39.967365, -75.172827);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'RockyStatue.jpg','Rocky Statue','Rocky won the Oscar for Best Picture in 1986. There are no statues of Thunderlips, George Washington Duke, or Clubber Lang.','Rocky was filmed on a budget of less than $1 million.', 10, 39.965041, -75.179338);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'ArtMuseumSteps.jpg','Rocky Steps','There are 72 Rocky Steps. The steps appear in every film except Rocky IV.','Challenge: Rocky ran up the steps in 10.2 seconds. See if you can beat his time.', 10, 39.964938, -75.180148);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'StAugustine.jpg','St. Augustine','Haunted Cole, played by Haley Joel Osment, attempts to seek refuge in St. Augustine''s church in The Sixth Sense.','Beware of men who wear all black lerking around.', 10, 39.955527, -75.146646);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'CityHall.jpg','City Hall','City Hall is featured in Philadelphia, Twelve Monkeys, Transformers: Revenge of the Fallen, and a variety of other films.','City Hall can be seen in the background of the final scene in Rocky.', 10, 39.952443, -75.164828);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'UnionLeague.jpg','Union League','The Union League stars as the "Heritage Club" in the movie Trading Places. Go long on frozen concentrated orange juice and pork bellies. ','Look out for Clarence Beeks selling false crop reports.', 10, 39.949930, -75.164315);
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'30thStreetStation.jpg','30th Street Station','Witness was filmed at 30th Street Station. In the film, a young Amish boy witnesses a murder here and is protected by Harrison Ford.','In Trading Places, Winthorpe and Valentine depart for NYC here.', 10, 39.955673, -75.181465);


-- connect to hunt;
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'EasternStatePenn.jpg';
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'RockyStatue.jpg';
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'ArtMuseumSteps.jpg';
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'StAugustine.jpg';
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'CityHall.jpg';
insert into hunt_photo select photo_id, 1000 from photo where image_file_name = 'UnionLeague.jpg';



-- Penn Grad School
insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(nextval('hunt_id_seq'),2,'CityTavern.jpg', 'Places to See', 'Grad school doesn''t have to be all work and no play! Here are some interesting places on campus and off that you should visit during you time with Penn', 39.947095, -75.146900, 20);



-- load photos from excel
insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'katz-center.jpg','Penn''s Center for Judaic Studies','The Herbert D. Katz Center for Advanced Judaic Studies at the University of Pennsylvania is devoted to post-doctoral research on Jewish civilization in all its historical and cultural manifestations','The Katz Center was founded in 1907 as the Dropsie College of Hebrew and Cognate Learning', 10, 39.947265, -75.148427);	
insert into hunt_photo select photo_id, 1001 from photo where title = 'Penn''s Center for Judaic Studies';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'polish-american-cultural','Polish American Cultural Center','The Cultural Center and Exhibit Hall are outgrowths of Polish American Social Services (PASS), an agency dating back to 1908 to address the social service needs of the substantial Polish American population in Philadelphia.','Philadelphia is home to the 4th largest Polish population in the U.S.', 10, 39.947095, -75.146900);	
insert into hunt_photo select photo_id, 1001 from photo where title = 'Polish American Cultural Center';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'Ritz.jpg','Ritz 5 Theater','Founded by Ramon L. Posel as a three screen theatre in 1976, then converted to five screen in 1985, this classic theatre was one of the first to bring arthouse films to Philadelphia','Historically, a "bourse" is a stock exchange. Philadelphia''s "bourse" was in the first in the world to house a livestock, maritime, and grain trading exchange center simultaneously.', 10, 39.946726, -75.145583);	
insert into hunt_photo select photo_id, 1001 from photo where title = 'Ritz 5 Theater';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'MerchantExchange.jpg','Merchant''s Exchange','The Merchant''s Exchange is the oldest stock exchange building in the United States and was the original hub for financial and commercial activities.','Designed by William Strickland, one of the foremost 19th-century architects, and built between 1832 and 1834.', 10, 39.947263, -75.145908);	
insert into hunt_photo select photo_id, 1001 from photo where title = 'Merchant''s Exchange';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'CityTavern.jpg','City Tavern','A reconstructed Colonial tavern where servers in period dress deliver old-fashioned American fare.','Nice work, feel free to buy Ben Franklin a beer for his influence on Philadelphia', 10, 39.947098, -75.144460);	
insert into hunt_photo select photo_id, 1001 from photo where title = 'City Tavern';


-- Seaport Musuem
insert into place(place_id, image_file_name, name, description, latitude, longitude)
values(nextval('place_id_seq'),'SeaportMuseum.png', 'Seaport Museum', 'Explore Philadelphia''s only maritime museum! See nautical art, interactive exhibits, the Workshop on the Water, and our two historic ships!', 39.945949, -75.140374);

insert into hunt(hunt_id, place_id, image_file_name, name, description, latitude, longitude, points)
values(nextval('hunt_id_seq'),currval('place_id_seq'),'USSOlympia.png', 'Our Boats', 'See our two historic ships - the cruiser Olympia, the oldest steel warship still afloat in the world and the WWII-era submarine Becuna', 39.945949, -75.140374, 20);


insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'SeaportMuseum.png','The Museum','Explore Philadelphia''s only maritime museum! See nautical art, interactive exhibits, the Workshop on the Water, and our two historic ships!','CHALLENGE: Take a pictue of your best sailor salute and post it to us @phillyseaport', 10, 39.945949, -75.140374);
insert into hunt_photo select photo_id, currval('hunt_id_seq') from photo where title = 'The Museum';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'USSOlympia.png','USS Olympia','Launched in 1892, The Olympia is the oldest steel warship afloat in the world.','Olympia is a rare treasure in the U.S. naval fleet, as no sister ships were ever built.', 10, 39.944562, -75.141181);	
insert into hunt_photo select photo_id, currval('hunt_id_seq') from photo where title = 'USS Olympia';

insert into photo(photo_id, account_id, image_file_name, title, description,found_msg, points, latitude, longitude) values(nextval('photo_id_seq'),1,'Becuna.png','Becuna Sub','Becuna is a BALAO-class submarine built in New London, CT. During World War II, "Becky" prowled the Pacific Ocean for Japanese ships, and is credited with sinking 3.5 Japanese merchant ships.','DID YOU KNOW: You can get special behind the scene tours the first Saturday of every month, Noon - 4 pm, April through December.', 10, 39.944562, -75.141181);	
insert into hunt_photo select photo_id, currval('hunt_id_seq') from photo where title = 'Becuna Sub';