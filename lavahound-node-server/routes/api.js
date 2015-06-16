var express = require('express');
var router = express.Router();           // get an instance of the express Router

var pg = require('pg');
var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";

var fs         = require('fs');
var sha1       = require('sha1');

var publicUrls = ["/sign-in", "/sign-up"]

// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log(req.path);

    console.log("API:", req.query.api_token);

    if (publicUrls.indexOf(req.path) < 0){
        pg.connect(connectionString, function(err, client, done) {
          if(err) {
            console.log(err);
            return console.error('error fetching client from pool', err);
          }
          client.query('SELECT account_id from account where remember_me_token = $1', [req.query.api_token], function(err, result) {
            //call `done()` to release the client back to the pool 
            // console.log(err, result);
            
            if(err) {
                // console.log(query, err);
                return res.status(404).json({"error_message": err});    
            }
            done();
            if (result.rows.length != 1)
                return res.status(403).json({"error_message": "Please login to use the app"});    
            else{
                console.log("ACCOUNT_ID: ",result.rows[0].account_id)
                req.account_id = result.rows[0].account_id;
            }
            next();
          });
        });
    }else{
        //public url
        next();
    }
    // console.log("QUERY:",req.query);
    // console.log("BODY:",req.body);

    // add check for logged in

 // make sure we go to the next routes and don't stop here
});

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
    var token = sha1(email);
    console.log(email, hash);


    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("insert into account(account_id, name, email, password, remember_me_token) " +
            "values(nextval('account_id_seq'), $1, $2, $3, $4)", [displayName, email, hash, token]);

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
            return res.json({ api_token: token, total_points: 0 });   
        }
    });
});

router.get('/places/nearby', function(req, res) {
    var results = [];

    // lng=-122.0304785247098&lat=37.33240841337464
    if (!req.query.lat || !req.query.lng)
        return res.json({"error_message": "Please turn on location services to play"});    
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
            row.image_url = cloudfront_base + "sm_" + row.image_file_name;
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
            row.image_url = cloudfront_base + row.image_file_name;
            results.place = row;
        });

        // SQL Query > Select Data
        var huntQuery = client.query("select h.*, count(hp.photo_id) as total_count, count(pf.photo_id) as found_count  " +
                "from hunt h, hunt_photo hp left outer join photo_found pf on pf.photo_id = hp.photo_id and pf.account_id = $1 where h.place_id = $2 and h.hunt_id = hp.hunt_id " +
                "group by h.hunt_id", [req.account_id, req.query.place_id]);
        // console.log(query);
        // Stream results back one row at a time
        huntQuery.on('row', function(row) {
            row.image_url = cloudfront_base + row.image_file_name;
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
        var query = client.query("select p.*, round((point(p.longitude, p.latitude) <@> point($1,$2))::numeric, 2) as miles, count(pf1.photo_id) as found from photo p " +
            "left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $3, hunt_photo hp where hp.hunt_id = $4 and hp.photo_id = p.photo_id " +
            "group by p.photo_id order by round((point(p.longitude, p.latitude) <@> point($5,$6))::numeric, 3)", [lng, lat,req.account_id, req.params.hunt_id, lng, lat]);
        console.log(query);
        // Stream results back one row at a time
        query.on('row', function(row) {
            row.image_url = cloudfront_base + "sm_" + row.image_file_name;
            console.log(row.title, "=>", row.image_url);
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
        var query = client.query("select p.*, count(pf.photo_id) as times_found, count(pf1.photo_id) >0 as found from photo p left outer join photo_found pf on pf.photo_id = p.photo_id " +
            "left outer join photo_found pf1 on pf1.photo_id = $1 and pf1.account_id = $2 WHERE p.photo_id = $3 group by p.photo_id", [parseInt(req.params.photo_id), parseInt(req.account_id), parseInt(req.params.photo_id)]);
        // console.log(query);
        // var query = client.query("select p.* from photo p");
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
          console.log("Error:", err);
        }
    });
});

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' });   
});

router.get('/photos/found/:photo_id', function(req, res) {
    var points = 0;
    var found_msg = "";


// var Client = require('pg').Client;

// var client = new Client(connectionString);
// client.connect();

// var rollback = function(client, err) {
//   //terminating a client connection will
//   //automatically rollback any uncommitted transactions
//   //so while it's not technically mandatory to call
//   //ROLLBACK it is cleaner and more correct
//   client.query('ROLLBACK', function() {
//     client.end();
//   });
//   return res.status(400).json({"error_message": err});
// };

// client.query('BEGIN', function(err, result) {
//   if(err) return rollback(client, err);
//   client.query('insert into photo_found(photo_id, account_id) values($1, $2)', [req.params.photo_id, req.account_id], function (err, results) {
//     if(err) return rollback(client, err);
//     client.query('select points, found_msg from photo p where p.photo_id = $1', req.params.photo_id, function (err, results) {
//       if(err) return rollback(client, err);
//       //disconnect after successful commit
//       client.query('COMMIT', client.end.bind(client));
//         points = results[0].points;
//         found_msg = results[0].found_msg;
//         console.log("Points: ", points, found_msg);
//         res.json({ total_points: points.toString(), message: found_msg, points: points.toString() });        
//     });
//   });
// });

    console.log("Found: ", req.params.photo_id, req.account_id);
    // http://baudehlo.com/2014/04/28/node-js-multiple-query-transactions/
    pg.connect(connectionString, function(err, client, done) {
        if(err) {
            console.log("step1:",err);
            return res.status(400).json({"error_message": err});
        }else{
            client.query("insert into photo_found(photo_id, account_id) values($1, $2)", [req.params.photo_id, req.account_id], function (err, results) {
                if(err) {
                    console.log("step2:",err);
                    // done();
                    return res.status(400).json({"error_message": err}); 
                }else{
                // client.query("select sum(points) from photo p, photo_found pf where p.photo_id = pf.photo_id and pf.account_id = $1", req.account_id, function (err, results) {
                    client.query('select points, found_msg from photo p where p.photo_id = $1', [req.params.photo_id], function (err, results) {
                        if(err) {
                            // console.log(query, err);
                            // done();
                            return res.status(400).json({"error_message": err});  
                        }else{
                            console.log("results", results);
                            points = results.rows[0].points;
                            found_msg = results.rows[0].found_msg;
                            console.log("Points: ", points, found_msg);
                            res.json({ total_points: points.toString(), message: found_msg, points: points.toString() });   
                        }
                        done();
                    });
                }
            });
        }
    });
});


router.post('/photos/flag', function(req, res) {
    res.json({});
});

router.get('/users/show', function(req, res) {
    res.sendfile('pages/profile.html');
});


router.get('/users/points', function(req, res) {
    var totalpoints = 0;
    //     NSNumber *_total;
    // NSNumber *_finder;
    // NSNumber *_hider;
    // NSNumber *_royalties;
    // NSString *_rank;    
    // NSString *_rankPercentile;    
    // NSString *_rankDescription
    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("select sum(points) as totalpoints from photo p, photo_found pf where p.photo_id = pf.photo_id and pf.account_id = $1", [req.account_id]);

        // console.log(query);
        // var query = client.query("select p.* from photo p");
        // Stream results back one row at a time
        query.on('row', function(row) {
            totalpoints = row.totalpoints;
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            // return res.json(results);
            res.json({points: { total: totalpoints, finder: totalpoints, hider: 0, royalties: 0, rank: "3", rank_percentile: "5%", rank_description: "Rockstar" }});   

        });

        // Handle Errors
        if(err) {
          console.log("Error:", err);
        }
    });

});

module.exports = router;