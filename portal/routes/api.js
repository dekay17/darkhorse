var async = require('async');
var fs = require('fs');

var express = require('express');
var multer  = require('multer')

var storage = multer.diskStorage({
  destination: './uploads/',
    filename: function (req, file, cb) {
        cb(null, file.originalname)
    }
})

var upload = multer({ storage: storage});

var ExifImage = require('exif').ExifImage;
var geolib = require('geolib');

var router = express.Router();

var pg = require('pg');
var sha1 = require('sha1');

pg.defaults.poolSize = 20;

var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';
//var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:lavahound@107.21.239.118:5432/lavahound';



var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";
var user_icon_base = "https://s3.amazonaws.com/user-icons/";

var AWS = require('aws-sdk');
AWS.config.region = 'us-east-1';

AWS.config.accessKeyId = 'AKIAIFYVEREBTRW5R55A';
AWS.config.secretAccessKey = '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';

var publicUrls = ["/sign-in", "/sign-up", "/terms-and-conditions", "/privacy-policy"]

/* GET home page. */
router.get('/dashboard/summary', function(req, res, next) {
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.hunts = [];
        jsonResults.accounts = {};


        var huntQuery = function(callback) {
            client.query("select count(*) as hunt_count from hunt" ,
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed huntQuery");
                    jsonResults.hunts = result.rows[0].hunt_count;
                    callback(null, result[0]);
                });
        }


        // SQL Query > Select Data
        var accountQuery = function(callback) {
            client.query("select count(*) as account_count from account",
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed huntQuery");
                    jsonResults.accounts = result.rows[0].account_count;
                    callback(null, result);
                });
        }

        async.parallel([
            huntQuery,
            accountQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data", 
                    "error_description": err
                });
            return res.json(jsonResults);
        });

    });
});

router.get('/places', function(req, res, next) {
	pg.connect(connectionString, function(err, client, done) {

        // SQL Query > Select Data
		var results = [];
        var queryText = "select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude, count(hunt_id) hunt_count " +
            "from place p, hunt h " +
            "where h.active = true and p.place_id = h.place_id "
        queryText += "group by p.place_id, p.name,p.description, p.image_file_name,p.latitude,p.longitude order by p.name"
        console.log(queryText);
        var query = client.query(queryText);
        console.log(query);
        // Stream results back one row at a time
        query.on('row', function(row) {
            row.image_url = cloudfront_base + "sm_" + row.image_file_name;
            //row.proximity_description = row.miles + " miles";
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

router.post('/place/', function(req, res, next) {
    console.log("add place", req.body);

    var place = req.body.place;
    pg.connect(connectionString, function(err, client, done) {
        client.query(
            "insert into place(place_id, image_file_name, name, description, latitude, longitude) " +
            "values(nextval('place_id_seq'),$1,$2,$3,0, 0) RETURNING place_id;",[place.name, place.image_file_name, place.description], 
            function(err, result) {

                if (err) {
                    return res.status(400).json({
                        "error_message": "error loading data", 
                        "error_description": err
                    });
                } else {
                    return res.json({place_id: result.rows[0].place_id});               
                }
                done();
            });        
    });
});

router.post('/place/:place_id', function(req, res, next) {
    console.log("edit place", req.body);
});

router.get('/place/:place_id', function(req, res, next) {
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.hunts = [];
        jsonResults.place = {};
	
        var placeQuery = function(callback){
        	client.query("select * from hunt where place_id = " + req.params.place_id).on('row', function(row) {
		        row.image_url = cloudfront_base + "sm_" + row.image_file_name;
		        jsonResults.hunts.push(row);
		    }).on('end', function(result) {
                done();
                if (err)
                    return callback(err);
                console.log("completed placeQuery");
                callback(null, result);
            });
	    }


	    // SQL Query > Select Data
	    var huntQuery = function(callback) {
	        client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude " +        
	    	        "from place p where p.place_id = " + req.params.place_id,
	            function(err, result) {
	                done();
	                if (err)
	                    return callback(err);
	                console.log("completed huntQuery");
	                jsonResults.place = result.rows[0];
	                callback(null, result);
	            });
	    }
	
	    async.parallel([
	        placeQuery,
	        huntQuery
	    ], function(err, results) {
	        if (err)
	            return res.status(400).json({
	                "error_message": "error loading data", 
	                "error_description": err
	            });
	        return res.json(jsonResults);
	    });	
	});
});

router.get('/hunt/:hunt_id', function(req, res, next) {
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.hunt = {};
        jsonResults.photos = [];
    
        var photoQuery = function(callback){
            client.query("select p.* from hunt_photo hp, photo p where hp.hunt_id = $1 and hp.photo_id = p.photo_id", [req.params.hunt_id]).on('row', function(row) {
                row.image_url = cloudfront_base + row.image_file_name;
                jsonResults.photos.push(row);
            }).on('end', function(result) {
                done();
                if (err)
                    return callback(err);
                console.log("completed photoQuery");
                callback(null, result);
            });
        }


        // SQL Query > Select Data
        var huntQuery = function(callback) {
            client.query("select p.place_id, p.name, p.description, p.image_file_name, p.latitude, p.longitude " +        
                    "from place p where p.place_id = " + req.params.hunt_id,
                function(err, result) {
                    done();
                    if (err)
                        return callback(err);
                    console.log("completed huntQuery");
                    jsonResults.hunt = result.rows[0];
                    callback(null, result);
                });
        }
    
        async.parallel([
            photoQuery,
            huntQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data", 
                    "error_description": err
                });
            return res.json(jsonResults);
        }); 
    });
});

router.get('/timeline', function(req, res, next) {
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.events = [];
    
        var photoQuery = function(callback){
            client.query("select p.photo_id, p.image_file_name, p.title, a.name, pf.created_date, EXTRACT(EPOCH FROM pf.created_date) * 1000 as timestamp " +
                "from photo p, account a, photo_found pf " +
                "where pf.photo_id = p.photo_id and pf.account_id = a.account_id " +
                "order by pf.created_date desc limit 10").on('row', function(row) {
                row.image_url = cloudfront_base + row.image_file_name;
                jsonResults.events.push(row);
            }).on('end', function(result) {
                done();
                if (err)
                    return callback(err);
                console.log("completed photoQuery");
                callback(null, result);
            });
        }

        async.parallel([
            photoQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data", 
                    "error_description": err
                });
            return res.json(jsonResults);
        }); 
    });
});


router.get('/accounts', function(req, res, next) {
    pg.connect(connectionString, function(err, client, done) {
        var jsonResults = {};
        jsonResults.accounts = [];
    
        var photoQuery = function(callback){
            client.query("select account_id, email, name from account").on('row', function(row) {
                jsonResults.accounts.push(row);
            }).on('end', function(result) {
                done();
                if (err)
                    return callback(err);
                console.log("completed photoQuery");
                callback(null, result);
            });
        }

        async.parallel([
            photoQuery
        ], function(err, results) {
            if (err)
                return res.status(400).json({
                    "error_message": "error loading data", 
                    "error_description": err
                });
            return res.json(jsonResults);
        }); 
    });
});





router.post('/upload', upload.single('file'), function(req, res) {
    console.log("upload", req.file.path);

    new ExifImage({ image : req.file.path }, function (error, exifData) {
        if (error){
            console.log('Error: '+error.message);
            return res.status(500).json({
                    "error": error.message
            });
        }else{
            var sexagesimalLat = exifData.gps.GPSLatitude[0] + "° " + exifData.gps.GPSLatitude[1] +"' " + exifData.gps.GPSLatitude[2] + "\" " + exifData.gps.GPSLatitudeRef;
            var sexagesimalLng = exifData.gps.GPSLongitude[0] + "° " + exifData.gps.GPSLongitude[1] +"' " + exifData.gps.GPSLongitude[2] + "\" " + exifData.gps.GPSLongitudeRef;
            var lat = geolib.sexagesimal2decimal(sexagesimalLat);
            var lng = geolib.sexagesimal2decimal(sexagesimalLng);
            console.log(lat + "," + lng + "\t" + path.basename(filename)); 
            // console.log("39.955846, -75.182942");
            console.log(exifData.gps); 
                return res.status(200).json({
                    "filename": req.file.filename 
                });

        }
    });
    // fs.readFile(req.files.file.path, function (err, data) {
    //     var params = {Bucket: 'lavahound-hunts', Key: 'key', Body: data};
    //     s3.upload(params, options, function(err, data) {
    //       console.log(err, data);
    //     });
    //   // var newPath = __dirname + "/uploads/uploadedFileName";
    //   // fs.writeFile(newPath, data, function (err) {
    //   //   res.redirect("back");
    //   // });
    // });
});


router.post('/sign-out', function(req, res) {

});

router.post('/sign-in', function(req, res) {
    var password = req.body.password;
    var email = req.body.emailAddress;
    var hash = sha1(password);

    pg.connect(connectionString, function(err, client, done) {
        var token, name = null;
        // SQL Query > Select Data
        console.log(email, hash);
        var query = client.query("select email, name, remember_me_token " +
            "from account ac where email = $1 and password = $2", [email, hash]);
        // console.log(query);
        // After all data is returned, close connection and return results
        query.on('row', function(row) {
            token = row.remember_me_token;
            name = row.name;
        });

        query.on('end', function() {
            done();
            console.log('after', email, token);
            if (token != null)
                return res.json({
                    api_token: token,
                    name: name,
                    email: email
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

module.exports = router;
