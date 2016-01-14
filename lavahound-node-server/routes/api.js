var async = require('async');
//var express = require('express');
//var router = express.Router(); // get an instance of the express Router

var pg = require('pg');
pg.defaults.poolSize = 20;

var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";
var user_icon_base = "https://s3.amazonaws.com/user-icons/";

var fs = require('fs');
var sha1 = require('sha1');
var geolib = require('geolib');
var bodyParser = require('body-parser');
var randtoken = require('rand-token');

var publicUrls = ["/sign-in", "/sign-up", "/twitter/sign-in","/users/reset", "/terms-and-conditions", "/privacy-policy"]

var nodemailer = require("nodemailer");
var sesTransport = require('nodemailer-ses-transport');

// IAM User Name   ses-smtp-user.20150904-154133
// Smtp Username   AKIAIRQ5JDSTPVUCZOAQ
// Smtp Password   Al+Emw9h0k6iuh1ZD865QZ0/m+o3ydvslLyPbirNErG8

// Access Key ID:AKIAJTAWYW2FCCRPBCCA
//Secret Access Key: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

var transporter = nodemailer.createTransport(sesTransport({
    accessKeyId: "AKIAJTAWYW2FCCRPBCCA",
    secretAccessKey: "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",
    rateLimit: 5
}));

var FIND_DISTANCE = 15;

var LAVAHOUND_ACCOUNT = 1000;

var TWITTER_ACCOUNT = 1001;

var adminIds = [1, 1003, 1010];
module.exports = function(app, express) {
        app.use(bodyParser.json());

        var router = express.Router();
        // middleware to use for all requests
        router.use(function(req, res, next) {
            // console.log(req);
            // do logging
            console.log("Checking Token :", req.query.api_token, " for ", req.method ," to ",req.path);

            if (publicUrls.indexOf(req.path) < 0) {

                pg.connect(connectionString, function(err, client, done) {
                    if (err) {
                        console.log(err);
                        return console.error('error fetching client from pool', err);
                    }
                    client.query('SELECT account_id from account where remember_me_token = $1', [req.query.api_token], function(err, result) {
                        //call `done()` to release the client back to the pool 
                        done();

                        if (err) {
                            // console.log(query, err);
                            return res.status(404).json({
                                "error_message": err
                            });
                        }

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
                console.log("Public URL");

                next();
            }

        });

        router.get('/terms-and-conditions', function(req, res, next) {
            // res.render('index', { title: 'Express' });
            res.render('terms', {
                layout: false
            });
        });

        router.get('/privacy-policy', function(req, res, next) {
            // res.render('index', { title: 'Express' });
            res.render('privacy', {
                layout: false
            });
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
        });


        router.post('/twitter/sign-in', function(req, res) {
            var displayName = req.body.displayName;
            console.log(displayName);
            var token = sha1(req.body.authToken);

            pg.connect(connectionString, function(err, client, done) {
                if (err) {
                    return console.error('error fetching client from pool', err);
                }

                console.log("checking " + req.body.userId);
                client.query("select email, remember_me_token, COALESCE(sum(points), 0) as total_points " +
                    "from account ac left outer join hunt_points hp on ac.account_id = hp.account_id " +
                    "where email = $1 group by email, remember_me_token", [req.body.userId],
                    function(err, result) {
                        if (!err) {
                            console.log("found " + result.rows.length);
                            if (result.rows.length == 1) {
                                return res.json({
                                    api_token: result.rows[0].remember_me_token,
                                    total_points: result.rows[0].total_points
                                });
                            } else {
                                console.log("inserting " + req.body.userId);
                                client.query("insert into account(account_id, name, email, authtoken, authtokensecret, remember_me_token, accounttype, password) " +
                                    "values(nextval('account_id_seq'), $1, $2, $3, $4, $5, $6, $7)", [displayName, req.body.userId, req.body.authToken, req.body.authTokenSecret, token, TWITTER_ACCOUNT, token],
                                    function(err, result) {
                                        if (!err) {
                                            return res.json({
                                                api_token: token,
                                                total_points: "0"
                                            });
                                        } else {
                                            return res.status(400).json({
                                                "error_message": err.detail
                                            });
                                        }
                                    });
                            }
                        } else {
                            return res.status(400).json({
                                "error_message": err.detail
                            });
                        }
                    });
            });
        });

        router.get('/sign-up', function(req, res) {
            var displayName = req.query.display_name;
            var password = req.query.password;
            var passwordConfirm = req.query.password_confirm;
            var email = req.query.email_address;
            console.log(displayName);
            var hash = sha1(password);
            var token = sha1(email);
            console.log(email, hash);

            if (!email){
                    return res.status(400).json({
                        "error_message": "Sorry, must provide an email"
                    });                
            }
            if (!password || !passwordConfirm || (password.trim() != passwordConfirm.trim())){
                    return res.status(400).json({
                        "error_message": "Sorry, passwords don't match"
                    });                
            }



            pg.connect(connectionString, function(err, client, done) {

                // SQL Query > Select Data
                var query = client.query("insert into account(account_id, name, email, password, remember_me_token) " +
                    "values(nextval('account_id_seq'), $1, $2, $3, $4)", [displayName, email, hash, token]);

                // After all data is returned, close connection and return results
                query.on('end', function() {
                    client.end();
                    var msgHtml = "Welcome to Lavahound";
                    var msgText = "Welcome to Lavahound";

                    var mailOptions = {
                        from: 'dan+lavahound@kelleyland.com', // sender address
                        to: [email], // list of receivers
                        subject: 'Welcome to Lavahound', // Subject line
                        text: msgText, // plaintext body
                        html: msgHtml // html body
                    };

                    // // console.log(mailOptions);
                    transporter.sendMail(mailOptions, function(error, info) {
                        if (error) {
                            console.log(error);
                        }
                        console.log('Message sent: ' + info);
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
            // if (!req.query.lat  !req.query.lng || !req.query.ne_lng || !req.query.ne_lat)
            //     return res.json({
            //         "error_message": "Please turn on location services to play"
            //     });
            // Get a Postgres client from the connection pool
            pg.connect(connectionString, function(err, client, done) {

                // SQL Query > Select Data
                var queryText = null
                if (req.query.lat) {
                    queryText = "select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude, count(hunt_id) hunt_count, " +
                        "round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 2) as miles " +
                        "from place p, hunt h " +
                        "where h.active = true and p.place_id = h.place_id "

                    if (adminIds.indexOf(parseInt(req.account_id)) == -1) {
                        queryText += " and p.active = true "
                    }
                    queryText += "group by p.place_id, p.name,p.description, p.image_file_name,p.latitude,p.longitude, miles  order by round((point(p.longitude, p.latitude) <@> point(" + req.query.lng + "," + req.query.lat + "))::numeric, 3)"
                } else {
                    queryText = "select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude, count(hunt_id) hunt_count from place p, hunt h " +
                        "where p.place_id = h.place_id and p.longitude <= " + req.query.ne_lng + " and p.longitude >= " + req.query.sw_lng + " and p.latitude <= " + req.query.ne_lat + " and p.latitude >= " + req.query.sw_lat
                        if (adminIds.indexOf(parseInt(req.account_id)) == -1) {
                            queryText += " and p.active = true "
                        }
                    queryText += " group by p.place_id, p.name,p.description, p.image_file_name,p.latitude,p.longitude"
                }
                console.log(queryText);
                var query = client.query(queryText);
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
                            result.rows[0].image_url = cloudfront_base + result.rows[0].image_file_name;
                            jsonResults.place = result.rows[0];
                            callback(null, result[0]);
                        });
                }


                // SQL Query > Select Data
                var huntQuery = function(callback) {
                    client.query("select h.*, count(hp.photo_id) as total_count, count(pf.photo_id) as found_count  " +
                        "from hunt h, hunt_photo hp left outer join photo_found pf on pf.photo_id = hp.photo_id and pf.account_id = $1 where h.place_id = $2 and h.hunt_id = hp.hunt_id and h.active = true " +
                        "group by h.hunt_id", [req.account_id, req.query.place_id],
                        function(err, result) {
                            done();
                            if (err)
                                return callback(err);
                            console.log("completed huntQuery");
                            result.rows.forEach(function(row) {
                                row.image_url = cloudfront_base + "sm_" + row.image_file_name;
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
                    //client.end();
                    return res.json(jsonResults);

                });
            });
        });


        router.get('/hunts/:hunt_id/photos', function(req, res) {

            var results = {};
            results.photos = [];

            photoLocations = [];

            var lat = req.query.lat;
            var lng = req.query.lng;
            // Get a Postgres client from the connection pool
            pg.connect(connectionString, function(err, client, done) {

                // SQL Query > Select Data

                var query = client.query("select p.photo_id, p.account_id, p.image_file_name, p.title, p.description, p.found_msg, p.points, p.latitude, p.longitude, p.created_date, p.updated_date, p.submitter, round((point(p.longitude, p.latitude) <@> point($1,$2))::numeric, 2) as miles, count(pf1.photo_id) as found from " +
                    "photo p left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $3, hunt_photo hp where hp.hunt_id = $4 and hp.photo_id = p.photo_id and depends_on_photo is null " +
                    "group by p.photo_id, depends_on_photo union select  p.photo_id, p.account_id, p.image_file_name, p.title, p.description, p.found_msg, p.points, p.latitude, p.longitude, p.created_date, p.updated_date, p.submitter, round((point(p.longitude, p.latitude) <@> point($1,$2))::numeric, 2) as miles, 1 as found from photo p " + 
                    "left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $3, hunt_photo hp where hp.hunt_id = $4 and hp.photo_id = p.photo_id and hp.depends_on_photo is not null  and hp.depends_on_photo in (select photo_id " +
                    "from photo_found where account_id = $3) group by p.photo_id, depends_on_photo union " +
                    "select p.photo_id, p.account_id, 'locked_photo.jpg' as image_file_name, p.title, p.description, p.found_msg, p.points, 0 as latitude, 0 as longitude, p.created_date, p.updated_date, p.submitter, null as miles, 0 as found " +
                    "from photo p left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $3, hunt_photo hp " +
                    "where hp.hunt_id = $4 and hp.photo_id = p.photo_id and hp.depends_on_photo is not null and hp.depends_on_photo not in (select photo_id from photo_found where account_id = $3) " +
                    "group by p.photo_id, depends_on_photo order by miles", [lng, lat, req.account_id, req.params.hunt_id]);



                // var query = client.query("select p.*, round((point(p.longitude, p.latitude) <@> point($1,$2))::numeric, 2) as miles, count(pf1.photo_id) as found from photo p " +
                //     "left outer join photo_found pf1 on pf1.photo_id = p.photo_id and pf1.account_id = $3, hunt_photo hp where hp.hunt_id = $4 and hp.photo_id = p.photo_id " +
                //     "group by p.photo_id order by round((point(p.longitude, p.latitude) <@> point($5,$6))::numeric, 3)", [lng, lat, req.account_id, req.params.hunt_id, lng, lat]);
                console.log(query);
                // Stream results back one row at a time
                query.on('row', function(row) {
                    row.image_url = cloudfront_base + "sm_" + row.image_file_name;
                    // console.log(row.title, "=>", row.image_url);
                    if (row.miles != null)
                        row.proximity_description = row.miles + " miles";
                    else
                        row.proximity_description = "who knows!";

                    if (adminIds.indexOf(parseInt(req.account_id)) > -1) {
                        row.found = false;
                    }
                    if (row.latitude != 0 && row.longitude != 0){
                        photoLocations.push({
                            latitude: row.latitude,
                            longitude: row.longitude
                        });
                    }
                    results.photos.push(row);
                });



                // After all data is returned, close connection and return results
                query.on('end', function() {
                    client.end();
                    var center = geolib.getCenter(photoLocations);
                    results.latitude = center.latitude;
                    results.longitude = center.longitude;
                    return res.json(results);
                });

                // Handle Errors
                if (err) {
                    console.log(err);
                    return res.status(400).json({
                        "error_message": "Error loading hunt"
                    });
                }

            });

        });

        router.get('/scoreboard/hunt', function(req, res) {
            var results = {};
            results.huntscoreboard = [];

            pg.connect(connectionString, function(err, client, done) {

                // SQL Query > Select Data
                var query = client.query("SELECT id, username,totalpoints::integer, place::integer, 0 as huntrank FROM " +
                    "(SELECT a.account_id as id, a.name as username,points totalpoints,rank() OVER (ORDER BY points desc, a.name asc, a.account_id asc) as place " +
                    " FROM hunt_points hp, account a where hp.account_id = a.account_id and hunt_id = $1) AS ranking", [req.query.hunt_id]);
                // Stream results back one row at a time
                // console.log(query);

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
                    return res.status(400).json({
                        "error_message": "Error loading scoreboard"
                    });
                }

            });
        });

        router.get('/scoreboard/user', function(req, res) {

            return res.status(400).json({
                "error_message": "call not implemented"
            });
            // userscoreboard: [{
            //     huntname: "Discover Philly",
            //     huntrank: 2,
            //     id: 2,
            //     place: 1,
            //     username: "dan",
            //     "totalpoints": 70,
            //     "isUser": 1
            // }, {

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
                var query = client.query("select p.photo_id, p.account_id, p.image_file_name, p.title, p.description, p.found_msg, p.points, p.latitude, p.longitude, p.created_date, "+
                    " p.updated_date, p.submitter ,count(pf.photo_id) as times_found, count(pf1.photo_id) >0 as found from photo p left outer join photo_found pf on pf.photo_id = p.photo_id " +
                    "left outer join photo_found pf1 on pf1.photo_id = $1 and pf1.account_id = $2, hunt_photo hp WHERE p.photo_id = $1 and hp.photo_id = p.photo_id and " + //and hunt_id = 1000 
                    "(hp.depends_on_photo is null or hp.depends_on_photo in (select photo_id from photo_found where account_id = $2)) group by p.photo_id union select p.photo_id, p.account_id, " + 
                    "'locked_photo.jpg' as image_file_name, p.title, 'You need to unlock this picture to get the description' as description, p.found_msg, p.points, p.latitude, p.longitude, " + 
                    "p.created_date, p.updated_date, p.submitter ,count(pf.photo_id) as times_found, count(pf1.photo_id) >0 as found from photo p left outer join photo_found pf on pf.photo_id = p.photo_id " + 
                    "left outer join photo_found pf1 on pf1.photo_id = $1 and pf1.account_id = $2, hunt_photo hp WHERE p.photo_id = $1 and hp.photo_id = p.photo_id and hp.depends_on_photo is not null and hp.depends_on_photo " + //and hunt_id = 1000 
                    "not in (select photo_id from photo_found where account_id = $2) group by p.photo_id", [parseInt(req.params.photo_id), parseInt(req.account_id)]);
                console.log(query);
                // var query = client.query("select p.* from photo p");
                // Stream results back one row at a time
                query.on('row', function(row) {
                    row.image_url = cloudfront_base + row.image_file_name;
                    row.proximity_description = row.miles + " miles";
                    row.submitted_by_image_url = user_icon_base + row.submitter + ".jpg";
                    row.submitted_by = row.submitter;
                    row.shot_information = row.description;
                    if (adminIds.indexOf(parseInt(req.account_id)) > -1) {
                        row.found = false;
                    }
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
                var totalPointsQuery = function(callback) {
                    client.query('select update_hunt_points($1) as total_points', [req.account_id], function(err, result) {
                        done();
                        if (err)
                            return callback(err);
                        callback(null, result.rows[0]);
                    });
                }


                var query = client.query("select points, found_msg, latitude, longitude from photo p where p.photo_id = $1", [req.params.photo_id]);
                // console.log(query);
                // Stream results back one row at a time
                var initial_results = {};
                query.on('row', function(row) {
                    initial_results = row;
                });

                // After all data is returned, close connection and return results
                query.on('end', function() {
                    var queries = [foundQuery, totalPointsQuery];

                    var distanceCheckEnabled = true;
                    // if (adminIds.indexOf(parseInt(req.account_id)) > -1) {
                    //     queries = [totalPointsQuery];
                    //     distanceCheckEnabled = false;
                    // }

                    console.log("checking : ", initial_results.latitude, initial_results.longitude);
                    console.log("checking : ", req.query.lat, req.query.lng);

                    var meters = geolib.getDistance({
                        latitude: initial_results.latitude,
                        longitude: initial_results.longitude
                    }, {
                        latitude: req.query.lat,
                        longitude: req.query.lng
                    });

                    if (!distanceCheckEnabled || (meters < FIND_DISTANCE)) {
                        async.series(queries, function(err, results) {
                            if (err)
                                return res.status(400).json({
                                    "error": err,
                                    "error_message": "error loading data"
                                });
                            client.end();
                            var resultsLength = results.length;
                            var points = results[resultsLength - 1].total_points == null ? "0" : results[resultsLength - 1].total_points.toString();
				console.log("points", points);
                            return res.json({
                                distance: meters,
                                results: results,
                                total_points: points,
                                message: initial_results.found_msg,
                                points: initial_results.points.toString()
                            });
                        });
                    } else {
                        return res.status(400).json({
                            "error_message": "Almost there .. not",
                            "distance": meters,
                        });
                    }
                });

                // Handle Errors
                if (err) {
                    console.log(err);
                    return res.status(400).json({
                        "error_message": "Error loading hunt"
                    });
                }

                // var pointsQuery = function(callback) {
                //     client.query('select points, found_msg, latitude, longitude from photo p where p.photo_id = $1', [req.params.photo_id], function(err, result) {
                //         done();
                //         if (err)
                //             return callback(err);
                //         callback(null, result.rows[0]);
                //     });
                // }

            });
        });


        router.get('/photos/flag/:photo_id', function(req, res) {
            console.log("Flagged ", req.params.photo_id, req.account_id);
            console.log(req.query);
            return res.json({
                success: true
            });
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
                    client.query("SELECT username,totalpoints, account_id, user_rank FROM ( " +
                        "SELECT a.name as username,a.account_id, sum(points) totalpoints,rank() " +
                        "OVER (ORDER BY sum(points) desc) as user_rank " +
                        "FROM hunt_points hp, account a where hp.account_id = a.account_id group by a.name, a.account_id " +
                        ") AS ranking where account_id = $1", [req.account_id],
                        function(err, result) {
                            done();
                            if (err)
                                return callback(err);
                            console.log("completed userQuery", result.rows.length);
                            if (result.rows.length > 0) {
                                totalpoints = result.rows[0].totalpoints;
                                rank = result.rows[0].huntrank;
                                callback(null, result.rows[0]);
                            } else {
                                callback(null, {
                                    totalpoints: "0"
                                });
                            }
                        });
                }


                // SQL Query > Select Data
                var rankQuery = function(callback) {
                    client.query("select count(distinct account_id) as total from photo_found",
                        function(err, result) {
                            done();
                            if (err) {
                                return callback(err);
                            }
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
                    var user_rank = results[0].user_rank ? results[0].user_rank : results[1].total;
                    var percent = (user_rank / results[1].total);
                    var rank_percentile = Math.round(percent * 100);

                    return res.json({
                        results: results,
                        total_points: results[0].totalpoints,
                        points: {
                            total: results[0].totalpoints,
                            finder: results[0].totalpoints,
                            hider: 0,
                            royalties: 0,
                            rank: user_rank,
                            rank_percentile: rank_percentile + "%",
                            rank_description: get_rank_label(user_rank, results[1].total)
                        }
                    });
                });
            });
        });

        router.get('/users/reset', function(req, res) {
            var displayName = req.query.display_name;
            var email = req.query.email_address;

            var password = randtoken.uid(8)
            var hash = sha1(password);
            console.log("sending email to ", email, password);

            var msgHtml = "Your lavahound passord was reset to: <b>" + password + "</b>";
            var msgText = "Your lavahound passord was reset to:" + password;

            pg.connect(connectionString, function(err, client, done) {

                var query = client.query("update account set password = $1 where lower(email) = $2", [hash, email.toLowerCase()]);
                // console.log(query);
                // Stream results back one row at a time
                query.on('row', function(row) {
                    initial_results = row;
                });

                // After all data is returned, close connection and return results
                query.on('end', function() {
                    // console.log("updated password to", password);
                    var mailOptions = {
                        from: 'support@lavahound.com', // sender address
                        to: [email], // list of receivers
                        subject: 'New Lavahound Password', // Subject line
                        text: msgText, // plaintext body
                        html: msgHtml // html body
                    };

                    // // console.log(mailOptions);
                    transporter.sendMail(mailOptions, function(error, info) {
                        if (error) {
                            console.log(error);
                            return res.status(400).json({
                                error: error
                            });
                        }
                        console.log('Message sent: ' + info.response);
                        return res.json({
                            email: email,
                            response: info.response
                        });
                    });  
                });

                // Handle Errors
                if (err) {
                    console.log(err);
                    return res.status(400).json({
                        "error_message": "Error loading hunt"
                    });
                }
            });
        });

        router.get('/email-test', function(req, res) {
            var displayName = req.query.display_name;
            var email = req.query.email_address;
            var msgHtml = "<b>Welcome to Lavahound</b><br/>Please get started";
            var msgText = "Welcome to Lavahound";

            console.log("sending email to ", email);

            var mailOptions = {
                from: 'support@lavahound.com', // sender address
                to: [email], // list of receivers
                subject: 'Welcome to Lavahound', // Subject line
                text: msgText, // plaintext body
                html: msgHtml // html body
            };

            // // console.log(mailOptions);
            transporter.sendMail(mailOptions, function(error, info) {
                if (error) {
                    console.log(error);
                    return res.json({
                        error: error
                    });
                }
                console.log('Message sent: ' + info.response);
                return res.json({
                    email: email,
                    response: info.response
                });
            });
        });

        function get_rank_label(rank, total) {
            if (rank == 1)
                return "Top Dog"

            var percent = rank / total;
            if (percent < 0.02)
                return "Lavahound"

            var rank_description_array = ["St. Bernard", "Greyhound", "Dalmation", "Collie", "Golden Retreiver", "Black Lab", "Bassett Hound", "Beagle", "Poodle", "Chihuahua"];

            var index = Math.floor(percent * (rank_description_array.length - 1));
            return "Top #" + Math.round(percent * 100) + "% - " + rank_description_array[index];
        }
        return router;
    }
    //module.exports = router;
