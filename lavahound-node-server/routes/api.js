var async = require('async');
var express = require('express');
var router = express.Router(); // get an instance of the express Router

var pg = require('pg');
var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";

var fs = require('fs');
var sha1 = require('sha1');

var publicUrls = ["/sign-in", "/sign-up"]

var nodemailer = require("nodemailer");
var sesTransport = require('nodemailer-ses-transport');

var transporter = nodemailer.createTransport(sesTransport({
    accessKeyId: 'AKIAJCJVGOUGHUN4JVWQ',
    secretAccessKey: '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',
    rateLimit: 5
}));


// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log(req.path);

    console.log("API:", req.query.api_token);

    if (publicUrls.indexOf(req.path) < 0) {
        pg.connect(connectionString, function(err, client, done) {
            if (err) {
                console.log(err);
                return console.error('error fetching client from pool', err);
            }
            client.query('SELECT account_id from account where remember_me_token = $1', [req.query.api_token], function(err, result) {
                //call `done()` to release the client back to the pool 
                // console.log(err, result);

                if (err) {
                    // console.log(query, err);
                    return res.status(404).json({
                        "error_message": err
                    });
                }
                done();
                if (result.rows.length != 1)
                    return res.status(403).json({
                        "error_message": "Please login to use the app"
                    });
                else {
                    console.log("ACCOUNT_ID:", result.rows[0].account_id)
                    req.account_id = result.rows[0].account_id;
                }
                next();
            });
        });
    } else {
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
        var token, points = null;
        // SQL Query > Select Data
        console.log(email, hash);
        var query = client.query("select email, remember_me_token, COALESCE(sum(points), 0) as total_points " +
            "from account ac left outer join hunt_points hp on ac.account_id = hp.account_id " +
            "where email = $1 and password = $2 group by email, remember_me_token", [email, hash]);
        // console.log(query);
        // After all data is returned, close connection and return results
        query.on('row', function(row) {            
            token = row.remember_me_token;
            points = row.total_points;
        });

        query.on('end', function() {
            client.end();
            if (token != null)
                return res.json({
                    api_token: token,
                    total_points: points
                });
            else
                return res.status(400).json({
                    "error_message": "invalid login"
                });
            // return res.json(results);
        });

        // Handle Errors
        if (err) {
            console.log(err);
            return res.status(400).json({
                "error_message": err
            });
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
            var msgHtml = "Home:" + req.body.homeTeam + ":" + req.body.homeScore + "<br/>" + "Away:" + req.body.awayTeam + ":" + req.body.awayScore;
            var msgText = "Home:" + req.body.homeTeam + ":" + req.body.homeScore + "\n" + "Away:" + req.body.awayTeam + ":" + req.body.awayScore;

            var mailOptions = {
                from: 'dan+sllsepa@kelleyland.com', // sender address
                to: ['dan@kelleyland.com'], // list of receivers
                subject: 'SLLSEPA Score', // Subject line
                text: msgText, // plaintext body
                html: msgHtml // html body
            };

            // // console.log(mailOptions);
            transporter.sendMail(mailOptions, function(error, info) {
                if (error) {
                    console.log(error);
                }
                console.log('Message sent: ' + info.response);
            });

            return res.json({
                api_token: token,
                total_points: 0
            });
        });

        query.on('error', function(err) {
            console.log('Database error!', err);
            return res.status(400).json({
                "error_message": err.detail
            });
        });
    });
});

router.get('/places/nearby', function(req, res) {
    var results = [];

    // lng=-122.0304785247098&lat=37.33240841337464
    if (!req.query.lat || !req.query.lng)
        return res.json({
            "error_message": "Please turn on location services to play"
        });
    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude, count(hunt_id) hunt_count, " +
            "round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 2) as miles " +
            "from place p, hunt h where p.place_id = h.place_id group by p.place_id, p.name,p.description, p.image_file_name,p.latitude,p.longitude, miles  " +
            "order by round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 3)");

        // console.log(query);
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
            return res.json({
                "places": results
            });
        });

        // Handle Errors
        if (err) {
            console.log(err);
            return res.json({
                "error_message": err
            });
            // }else{
            //     console.log(results);
            //     return res.json({"places": results});   
        }

    });
});

router.post('/users/show', function(req, res) {
    res.json({
        user_id: 100,
        email_address: "dan@kelleyland.com",
        display_name: "Dan K",
        image_url: "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/A._S._Bradford_House.JPG/500px-A._S._Bradford_House.JPG",
        photos_hidden: 20,
        times_found: 100,
        rank: 3
    });
});


router.get('/hunts', function(req, res) {


    var results = [];

    // Get a Postgres client from the connection pool
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.hunts = [];
        jsonResults.place = {};


        var placeQuery = function(callback) {
            client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude " +
                "from place p where p.place_id = " + req.query.place_id,
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed placeQuery");
                    jsonResults.place = result.rows[0];
                    callback(null, result[0]);
                });
        }


        // SQL Query > Select Data
        var huntQuery = function(callback) {
            client.query("select h.*, count(hp.photo_id) as total_count, count(pf.photo_id) as found_count  " +
                "from hunt h, hunt_photo hp left outer join photo_found pf on pf.photo_id = hp.photo_id and pf.account_id = $1 where h.place_id = $2 and h.hunt_id = hp.hunt_id " +
                "group by h.hunt_id", [req.account_id, req.query.place_id],
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed huntQuery");
                    result.rows.forEach(function(row) {
                        row.image_url = cloudfront_base + row.image_file_name;
                        jsonResults.hunts.push(row);
                    });
                    callback(null, result);
                });
        }

        async.parallel([
            placeQuery,
            huntQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data"
                });
            // jsonResults.place = results[0];
            client.end();
            return res.json(jsonResults);

        });
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
            "group by p.photo_id order by round((point(p.longitude, p.latitude) <@> point($5,$6))::numeric, 3)", [lng, lat, req.account_id, req.params.hunt_id, lng, lat]);
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
        if (err) {
            console.log(err);
        }

    });

});

router.get('/scoreboard/hunt', function(req, res) {
    var results = {};
    results.huntscoreboard = [];

    pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
        var query = client.query("SELECT id, username,totalpoints::integer, place::integer, 0 as huntrank FROM (SELECT a.account_id as id, a.name as username,points totalpoints,rank() OVER (ORDER BY points desc) as place " +
            " FROM hunt_points hp, account a where hp.account_id = a.account_id and hunt_id = $1) AS ranking", [req.query.hunt_id]);
        // Stream results back one row at a time
        console.log(query);

        query.on('row', function(row) {
            results.huntscoreboard.push(row);
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        // Handle Errors
        if (err) {
            console.log(err);
        }

    });
});

router.get('/scoreboard/user', function(req, res) {
    res.json({
        userscoreboard: [{
            huntname: "Discover Philly",
            huntrank: 2,
            id: 2,
            place: 1,
            username: "dan",
            "totalpoints": 70,
            "isUser": 1
        }, {
            huntname: "Campus Treasures",
            huntrank: 5,
            id: 1,
            place: 1,
            username: "sean",
            "totalpoints": 30,
            "isUser": 1
        }, {
            huntname: "Where is Ben?",
            huntrank: 8,
            id: 2,
            place: 1,
            username: "dan",
            "totalpoints": 20,
            "isUser": 1
        }]
    });
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
            row.shot_information = row.description;
            results = row;
        });

        // After all data is returned, close connection and return results
        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        // Handle Errors
        if (err) {
            console.log("Error:", err);
        }
    });
});

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({
        message: 'hooray! welcome to our api!'
    });
});

router.get('/photos/found/:photo_id', function(req, res) {
    console.log("Found: ", req.params.photo_id, req.account_id);

    // ---------------------
    pg.connect(connectionString, function(err, client, done) {

        var foundQuery = function(callback) {
            client.query("insert into photo_found(photo_id, account_id) values($1, $2)", [req.params.photo_id, req.account_id], function(err, result) {
                done();
                if (err)
                    return callback(err);
                callback(null, null);                                        
            });
        }


        // SQL Query > Select Data
        var pointsQuery = function(callback) {
            client.query('select points, found_msg from photo p where p.photo_id = $1', [req.params.photo_id], function(err, result) {
                done();
                if (err)
                    return callback(err);
                callback(null, result.rows[0]);
            });
        }

        var totalPointsQuery = function(callback) {
            client.query('select update_hunt_points($1) as total_points', [req.account_id], function(err, result) {
                done();
                if (err)
                    return callback(err);
                callback(null, result.rows[0]);
            });
        }

        async.series([
            foundQuery,
            pointsQuery,
            totalPointsQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error":err,
                    "error_message": "error loading data"
                });
            client.end();
            
            return res.json({
                results: results,   
                total_points: results[2].total_points.toString(),
                message: results[1].found_msg,
                points: results[1].points.toString()
            });
        });
    });





    // ------------------
    // http://baudehlo.com/2014/04/28/node-js-multiple-query-transactions/
    // pg.connect(connectionString, function(err, client, done) {
    //     if (err) {
    //         console.log("step1:", err);
    //         return res.status(400).json({
    //             "error_message": err
    //         });
    //     } else {
    //         client.query("insert into photo_found(photo_id, account_id) values($1, $2)", [req.params.photo_id, req.account_id], function(err, results) {
    //             if (err) {
    //                 console.log("step2:", err);
    //                 // done();
    //                 return res.status(400).json({
    //                     "error_message": err
    //                 });
    //             } else {
    //                 // client.query("select sum(points) from photo p, photo_found pf where p.photo_id = pf.photo_id and pf.account_id = $1", req.account_id, function (err, results) {
    //                 client.query('select points, found_msg from photo p where p.photo_id = $1', [req.params.photo_id], function(err, results) {
    //                     if (err) {
    //                         // console.log(query, err);
    //                         // done();
    //                         return res.status(400).json({
    //                             "error_message": err
    //                         });
    //                     } else {
    //                         console.log("results", results);
    //                         points = results.rows[0].points;
    //                         found_msg = results.rows[0].found_msg;
    //                         console.log("Points: ", points, found_msg);
    //                         res.json({
    //                             total_points: points.toString(),
    //                             message: found_msg,
    //                             points: points.toString()
    //                         });
    //                     }
    //                     done();
    //                 });
    //             }
    //         });
    //     }
    // });
});


router.post('/photos/flag', function(req, res) {
    res.json({});
});

router.get('/users/show', function(req, res) {
    res.sendfile('pages/profile.html');
});


router.get('/users/points', function(req, res) {
    var totalpoints, rank = 0;
    //     NSNumber *_total;
    // NSNumber *_finder;
    // NSNumber *_hider;
    // NSNumber *_royalties;
    // NSString *_rank;    
    // NSString *_rankPercentile;    
    // NSString *_rankDescription
    pg.connect(connectionString, function(err, client, done) {

        var userQuery = function(callback) {
            client.query("SELECT username,totalpoints, account_id, huntrank FROM ( " +
            "SELECT a.name as username,a.account_id, sum(points) totalpoints,rank() " +
            "OVER (ORDER BY sum(points) desc) as huntrank " +
            "FROM hunt_points hp, account a where hp.account_id = a.account_id group by a.name, a.account_id " +
            ") AS ranking where account_id = $1", [req.account_id], 
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed userQuery", result.rows.length);
                    if (result.rows.length > 0){
                        totalpoints = result.rows[0].totalpoints;
                        rank = result.rows[0].huntrank;
                        callback(null, result.rows[0]);
                    }else{
                        callback(null, {totalpoints: 0, rank:0});                        
                    }
                });
        }


        // SQL Query > Select Data
        var rankQuery = function(callback) {
            client.query("select count(distinct account_id) as total from photo_found",
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    callback(null, result.rows[0]);
                });
        }

        async.parallel([
            userQuery,
            rankQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data"
                });
            client.end();
            
            var rank_percentile = (results[0].huntrank / results[1].total)*100;

            return res.json({
                results: results,
                points: {
                    total: results[0].totalpoints,
                    finder: results[0].totalpoints,
                    hider: 0,
                    royalties: 0,
                    rank: results[0].rank,
                    rank_percentile: rank_percentile.toFixed(2) + "%",
                    rank_description: "Rockstar"
                }
            });
        });
    });
});

module.exports = router;