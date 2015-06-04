// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var fs         = require('fs');
var sha1       = require('sha1');


// connect to our database, comment out when disconnected
var pg = require('pg');
var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lv-place-logos/";

//var client = new pg.Client(connectionString);
//client.connect();
// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 3000;        // set our port

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log(req.path);
    // console.log("QUERY:",req.query);
    // console.log("BODY:",req.body);


    next(); // make sure we go to the next routes and don't stop here
});

// load hunt data
// var oduHunt, pennHunt, oleMissHunt;
// fs.readFile('hunts/odu.json', 'utf8', function (err, data) {
//   if (err) throw err;  
//   oduHunt = JSON.parse(data);
// });
// fs.readFile('hunts/penn.json', 'utf8', function (err, data) {
//   if (err) throw err;  
//   pennHunt = JSON.parse(data);
// });
// fs.readFile('hunts/olemiss.json', 'utf8', function (err, data) {
//   if (err) throw err;  
//   oleMissHunt = JSON.parse(data);
// });

// var oduPhotos, pennPhotos;
// fs.readFile('huntPhotos/odu.json', 'utf8', function (err, data) {
//   if (err) throw err;  
//   oduPhotos = JSON.parse(data);
// });
// fs.readFile('huntPhotos/penn.json', 'utf8', function (err, data) {
//   if (err) throw err;  
//   pennPhotos = JSON.parse(data);
// });

var foundImages = [28];
var userPoints = 20;

// lavahound test routes
router.get('/sign-in', function(req, res) {

    var password = req.query.password;
    var email = req.query.email_address;
    var hash = sha1(password);


    pg.connect(connectionString, function(err, client, done) {
        var token = null;
        // SQL Query > Select Data
        var query = client.query("select email, password, remember_me_token from account where email = $1 and password = $2", [email, hash]);
        console.log(query);
        // After all data is returned, close connection and return results
        query.on('row', function(row) {
            token = row.remember_me_token;
            console.log(row.remember_me_token, token);            
        });

        query.on('end', function() {
            client.end();
            if (token != null)
                return res.json({ api_token: token, total_points: 0 });   
            else
                return res.status(400).json({"error_message": "invalid login"}); 
            // return res.json(results);
        });

        // Handle Errors
        if(err) {
            console.log(err);
            return res.json({"error_message": err});    
        }
    });

    // res.json({ api_token: 'TEST123', total_points: userPoints });   
});


router.get('/sign-up', function(req, res) {
    var displayName = req.query.display_name;
    var password = req.query.password;
    var email = req.query.email_address;
    console.log(displayName);
    var hash = sha1(password);
    console.log(email, hash);


    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("insert into account(account_id, name, email, password, remember_me_token) " +
            "values(nextval('account_id_seq'), $1, $2, $3, $4)", [displayName, email, hash, hash]);

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            // return res.json(results);
        });

        // Handle Errors
        if(err) {
            console.log(err);
            return res.status(400).json({"error_message": err});    
        }else{
            return res.json({ api_token: hash, total_points: 0 });   
        }
    });
});

router.get('/places/nearby', function(req, res) {
    var results = [];

    // lng=-122.0304785247098&lat=37.33240841337464
    console.log(req.query.lat);
    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude, count(hunt_id) hunt_count, " +
                "round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 2) as miles " +
                "from place p, hunt h where p.place_id = h.place_id group by p.place_id, p.name,p.description, p.image_file_name,p.latitude,p.longitude, miles  " +
                "order by round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 3)");

        console.log(query);
        // Stream results back one row at a time
        query.on('row', function(row) {
            row.image_url = cloudfront_base + row.image_file_name;
            row.proximity_description = row.miles + " miles";
            results.push(row);
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            // return res.json(results);   
            return res.json({"places": results});            
        });

        // Handle Errors
        if(err) {
              console.log(err);
              return res.json({"error_message": err});    
        // }else{
        //     console.log(results);
        //     return res.json({"places": results});   
        }

    });
});

router.post('/users/show', function(req, res) {
    res.json({ user_id: 100, email_address: "dan@kelleyland.com", display_name: "Dan K",  image_url: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/A._S._Bradford_House.JPG/500px-A._S._Bradford_House.JPG", 
        photos_hidden: 20, times_found: 100, rank: 3});
});


router.get('/hunts', function(req, res) {    


    var results = [];

    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {
        var results = {};
        results.hunts = [];
        results.place = {};

        var placeQuery = client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude " +
                "from place p where p.place_id = " + req.query.place_id);
        placeQuery.on('row', function(row) {
            results.place = row;
        });

        // SQL Query > Select Data
        var huntQuery = client.query("select h.*, count(hp.photo_id) as total_count, count(pf.photo_id) as found_count  " +
                "from hunt h, hunt_photo hp left outer join photo_found pf on pf.photo_id = hp.photo_id and pf.account_id = $1 where h.hunt_id = $2 and h.hunt_id = hp.hunt_id " +
                "group by h.hunt_id", [req.query.place_id]);
        // console.log(query);
        // Stream results back one row at a time
        huntQuery.on('row', function(row) {
            results.hunts.push(row);
        });

        // After all data is returned, close connection and return results
        huntQuery.on('end', function() {
            client.end();
            return res.json(results);            
        });

        // Handle Errors
        if(err) {
          console.log(err);
        }

    });
});


router.get('/hunts/:hunt_id/photos', function(req, res) {

    // photo.photoId = [photoJson objectForKey:@"photo_id"];
    // photo.accountId = [photoJson objectForKey:@"account_id"];  
    // photo.points = [photoJson objectForKey:@"points"];  
    // photo.timesFound = [photoJson objectForKey:@"times_found"];      
    // photo.title = [photoJson objectForKey:@"title"];    
    // photo.description = [photoJson objectForKey:@"description"];        
    // photo.imageUrl = [photoJson objectForKey:@"image_url"];    
    // photo.latitude = [photoJson objectForKey:@"latitude"];    
    // photo.longitude = [photoJson objectForKey:@"longitude"];    
    // photo.proximityDescription = [photoJson objectForKey:@"proximity_description"];
    // photo.proximityColor = [photoJson objectForKey:@"proximity_color"];
    // photo.submittedBy = [photoJson objectForKey:@"submitted_by"];
    // photo.submittedByImageUrl = [photoJson objectForKey:@"submitted_by_image_url"];
    // photo.submittedOn = [photoJson objectForKey:@"submitted_on"];
    // photo.shotInformation = [[photoJson objectForKey:@"shot_information"] isKindOfClass:[NSString class]] ? [photoJson objectForKey:@"shot_information"] : nil;    
    // photo.found = [[photoJson objectForKey:@"found"] boolValue];
    // photo.owner = [[photoJson objectForKey:@"owner"] boolValue];   

    var results = {};
    results.photos = [];


    var lat = req.query.lat;
    var lng = req.query.lng;
    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("select p.*, round((point(p.longitude, p.latitude) <@> point($1, $2))::numeric, 2) as miles " +
                "from photo p, hunt_photo hp where hp.hunt_id = $3 and hp.photo_id = p.photo_id order by round((point(p.longitude, p.latitude) <@> point($4, $5))::numeric, 3)", [lng, lat, req.params.hunt_id, lng, lat]);

        // Stream results back one row at a time
        query.on('row', function(row) {
            row.image_url = cloudfront_base + row.image_file_name;
            row.proximity_description = row.miles + " miles";

            results.photos.push(row);
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        // Handle Errors
        if(err) {
          console.log(err);
        }

    });

    // var photos = pennPhotos
    // if (req.params.hunt_id != 1)
    //     photos = oduPhotos;  

    // var huntPhotos = photos.photos;
    // console.log(foundImages);    
    // for (var x=0;x<foundImages.length;x++){
    //     for (var y=0;y<huntPhotos.length;y++){
    //         // console.log(foundImages[x] == huntPhotos[y].photo_id, foundImages[x] , huntPhotos[y].photo_id);
    //         if (foundImages[x] == huntPhotos[y].photo_id )
    //             huntPhotos[y].found = 1;
    //     }
    // }
    // res.json(photos);  
});

router.get('/scoreboard/hunt', function(req, res) {
    console.log("userPoints", userPoints);
    res.json({huntscoreboard:[{huntname: "Campus Treasures", huntrank: "huntrank", id: 1, place: 1,username:"sean","totalpoints":100, "isUser": 1},
        {huntname: "Where is Ben?", huntrank: "huntrank", id: 2, place: 1,username:"dan","totalpoints":userPoints, "isUser": 1}]});
});

router.get('/scoreboard/user', function(req, res) {
    console.log("userPoints", userPoints);
    res.json({userscoreboard:[
        {huntname: "Discover Philly", huntrank: 2, id: 2, place: 1,username:"dan","totalpoints":70, "isUser": 1},
        {huntname: "Campus Treasures", huntrank: 5, id: 1, place: 1,username:"sean","totalpoints":30, "isUser": 1},
        {huntname: "Where is Ben?", huntrank: 8, id: 2, place: 1,username:"dan","totalpoints":userPoints, "isUser": 1}
        ]});
});

router.get('/photos/show/:photo_id', function(req, res) {

    // photo.photoId = [photoJson objectForKey:@"photo_id"];
    // photo.accountId = [photoJson objectForKey:@"account_id"];  
    // photo.points = [photoJson objectForKey:@"points"];  
    // photo.timesFound = [photoJson objectForKey:@"times_found"];      
    // photo.title = [photoJson objectForKey:@"title"];    
    // photo.description = [photoJson objectForKey:@"description"];        
    // photo.imageUrl = [photoJson objectForKey:@"image_url"];    
    // photo.latitude = [photoJson objectForKey:@"latitude"];    
    // photo.longitude = [photoJson objectForKey:@"longitude"];    
    // photo.proximityDescription = [photoJson objectForKey:@"proximity_description"];
    // photo.proximityColor = [photoJson objectForKey:@"proximity_color"];
    // photo.submittedBy = [photoJson objectForKey:@"submitted_by"];
    // photo.submittedByImageUrl = [photoJson objectForKey:@"submitted_by_image_url"];
    // photo.submittedOn = [photoJson objectForKey:@"submitted_on"];
    // photo.shotInformation = [[photoJson objectForKey:@"shot_information"] isKindOfClass:[NSString class]] ? [photoJson objectForKey:@"shot_information"] : nil;    
    // photo.found = [[photoJson objectForKey:@"found"] boolValue];
    // photo.owner = [[photoJson objectForKey:@"owner"] boolValue];   


    var results = {};
    // var lat = req.query.lat;
    // var lng = req.query.lng;

    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("select p.*, count(pf.photo_id) as times_found, count(pf1.photo_id) as found from photo p " +
            "left outer join photo_found pf on pf.photo_id = p.photo_id " +
            "left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $1 " +
            "group by p.photo_id", req.params.photo_id);

        console.log(query);
        // Stream results back one row at a time
        query.on('row', function(row) {
            row.image_url = cloudfront_base + row.image_file_name;
            row.proximity_description = row.miles + " miles";
            row.shot_information  = row.description;
            results = row;
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        // Handle Errors
        if(err) {
          console.log(err);
        }

    });
});

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' });   
});

router.post('/photos/found/:photo_id', function(req, res) {
    // foundImages
    foundImages.push(parseInt(req.params.photo_id));
    userPoints += 10
    if (req.params.photo_id == 29)
        res.json({ total_points: userPoints.toString(), message: "CHALLENGE: It is a custom to throw a pennie on Ben Franklin's grave.  Give it a try!", points: "10" });   
    else if (req.params.photo_id == 3)
            res.json({ total_points: userPoints.toString(), message: "\"LOVE\" can also be found in places like NYC, Kansas, Utah, Japan, China, and Kytgzstan. There is also a version showing the word in Italian (AMOR) in Milan, and one in Hebew (AHAVA) in Jerusalem.", points: "10" });   
    else
        res.json({ total_points: userPoints.toString(), message: "Awesome job, keep playing to earn more points!", points: "10" });   
});


router.post('/photos/flag', function(req, res) {
    res.json({});
});

router.get('/users/show', function(req, res) {
    res.sendfile('pages/profile.html');
});


router.get('/users/points', function(req, res) {
    //     NSNumber *_total;
    // NSNumber *_finder;
    // NSNumber *_hider;
    // NSNumber *_royalties;
    // NSString *_rank;    
    // NSString *_rankPercentile;    
    // NSString *_rankDescription
    res.json({points: { total: 10, finder: 1, hider: 2, royalties: 10, rank: "3", rank_percentile: "5%", rank_description: "Rockstar" }});   
});


// on routes that end in /bears
// ----------------------------------------------------
// router.route('/bears')

//     // create a bear (accessed at POST http://localhost:8080/api/bears)
//     .post(function(req, res) {
        
//         var bear = new Bear();      // create a new instance of the Bear model
//         console.log("creating bear:", req.body.name);
//         bear.name = req.body.name;  // set the bears name (comes from the request)

//         // save the bear and check for errors
//         bear.save(function(err) {
//             if (err)
//                 res.send(err);

//             res.json({ message: 'Bear created!' });
//         });
        
//     })

// // get all the bears (accessed at GET http://localhost:8080/api/bears)
//     .get(function(req, res) {
//         Bear.find(function(err, bears) {
//             if (err)
//                 res.send(err);

//             res.json(bears);
//         });
//     })

//  // update the bear with this id (accessed at PUT http://localhost:8080/api/bears/:bear_id)
//     .put(function(req, res) {

//         // use our bear model to find the bear we want
//         Bear.findById(req.params.bear_id, function(err, bear) {

//             if (err)
//                 res.send(err);

//             bear.name = req.body.name;  // update the bears info

//             // save the bear
//             bear.save(function(err) {
//                 if (err)
//                     res.send(err);

//                 res.json({ message: 'Bear updated!' });
//             });

//         });
//      })

//      .delete(function(req, res) {
//         Bear.remove({
//             _id: req.params.bear_id
//         }, function(err, bear) {
//             if (err)
//                 res.send(err);

//             res.json({ message: 'Successfully deleted' });
//     })
// });


// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);