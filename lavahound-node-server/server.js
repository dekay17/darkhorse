// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express');        // call express

var exphbs  = require('express-handlebars');
var path = require('path');

var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');

// Load routes
var api = require('./routes/api');
var web = require('./routes/index');

app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');

//var client = new pg.Client(connectionString);
//client.connect();
// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

var port = process.env.PORT || 3001;        // set our port

// ROUTES FOR OUR API
// =============================================================================


// REGISTER OUR ROUTES -------------------------------
app.use('/', web);
// all of our routes will be prefixed with /api
app.use('/api', api);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);