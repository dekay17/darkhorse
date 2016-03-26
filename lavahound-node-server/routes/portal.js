var express = require('express');
var router = express.Router();

var async = require('async');
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

var publicUrls = ["/sign-in", "/sign-up"]

var nodemailer = require("nodemailer");
var sesTransport = require('nodemailer-ses-transport');

var transporter = nodemailer.createTransport(sesTransport({
    accessKeyId: "AKIAJTAWYW2FCCRPBCCA",
    secretAccessKey: "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",
    rateLimit: 5
}));

var FIND_DISTANCE = 15;

var LAVAHOUND_ACCOUNT = 1000;

var TWITTER_ACCOUNT = 1001;


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
    

router.get('/sign-in', function(req, res, next) {
	// res.render('index', { title: 'Express' });
	res.render('portal/sign-in');
});

router.post('/sign-in', function(req, res) {

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
        
module.exports = router;
