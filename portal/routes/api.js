var async = require('async');

var express = require('express');
var router = express.Router();

var pg = require('pg');
var sha1 = require('sha1');

pg.defaults.poolSize = 20;

var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";
var user_icon_base = "https://s3.amazonaws.com/user-icons/";

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
            console.log('after', email, hash);
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
