var async = require('async');
var fs = require('fs');

var express = require('express');
var router = express.Router();

var pg = require('pg');
pg.defaults.poolSize = 20;

var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:h0und@localhost:5432/lavahound';
//var connectionString = process.env.DATABASE_URL || 'postgres://lavahound:lavahound@107.21.239.118:5432/lavahound';

var cloudfront_base = "https://s3.amazonaws.com/lavahound-hunts/";
var user_icon_base = "https://s3.amazonaws.com/user-icons/";

var publicUrls = ["/api/sign-in", "/sign-in", "/sign-up", "/terms-and-conditions", "/privacy-policy"]


router.use(function(req, res, next) {
    // do logging
    var token = req.cookies['X-API-Token']
	//console.log("cookies", req.cookies);
    console.log("checking token", token);
    if (token === 'undefined' || !token){
        console.log("checking header");
    	token = req.headers['x-api-token']
    }
    console.log("checking Token :", token, " for ", req.method ," to ",req.path);
    
    if (publicUrls.indexOf(req.path) < 0) {
        pg.connect(connectionString, function(err, client, done) {
            if (err) {
                console.log(err);
                return console.error('error fetching client from pool', err);
            }
            client.query('SELECT account_id from account where remember_me_token = $1', [token], function(err, result) {
                done();
                if (err) {                	
                    console.log(query, err);
                    return res.status(404).json({
                        "error_message": err
                    });
                }

                if (result.rows.length != 1){
                	console.log("error:", result.rows.length);
                    //console.log(query, result.rows.length);
                	res.writeHead(301,
  						{Location: '/sign-in'}
					);
	                res.end();
                    // return res.status(403).json({
                    //     "error_message": "Please login to use the app"
                    // });
                }else {
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

router.get('/', function(req, res, next) {
    var fileContents = fs.readFileSync("views/index.html");
    res.send(fileContents.toString());
});

/* GET home page. */
router.get('/home', function(req, res, next) {
    var fileContents = fs.readFileSync("views/index.html");
    res.send(fileContents.toString());
});

router.get('/crop', function(req, res, next) {
    var fileContents = fs.readFileSync("crop.html");
    res.send(fileContents.toString());
});

router.get('/sign-in', function(req, res, next) {
    // res.render('sign-in', {layout: false});
    var fileContents = fs.readFileSync("views/sign-in.html");
    res.send(fileContents.toString());
});

module.exports = router;
