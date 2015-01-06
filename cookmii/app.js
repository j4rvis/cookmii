var express = require("express");
var path = require("path");
var favicon = require("static-favicon");
var logger = require("morgan");
var cookieParser = require("cookie-parser");
var bodyParser = require("body-parser");
var methodOverride  = require('method-override');
var Promise = require("bluebird");
var mongoose = require('mongoose');
var passport = require('passport');
var session = require('express-session');
var flash = require('connect-flash');
var RedisStore = require('connect-redis')(session);

var routes = require("./app/routes");
var app = express();

app.locals.passport = passport;
require('./app/config/passport')(passport);
// mongoose.connect('mongodb://localhost:27017/cookmii_test');
mongoose.connect('mongodb://j4rvis:dbtest@ds029911.mongolab.com:29911/production');

app.locals.UserModel = require("./app/models/User");
app.locals.Recipe = require("./app/controller/RecipeController");
// view engine setup
app.set("views", path.join(__dirname, "app/views"));
app.set("view engine", "jade");
app.use(favicon());
app.use(logger("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(methodOverride());
app.use(express.static(path.join(__dirname, "public")));
app.use(session({
  store: new RedisStore({
    host: 'pub-redis-10898.eu-west-1-2.1.ec2.garantiadata.com',
    port: 10898,
    pass: 'dbtest'
  }),
  secret: 'ilovetullamore',
  saveUninitialized: true,
  resave: true
}));
app.use(passport.initialize());
app.use(passport.session());
app.use(flash());

app.use(function(req, res, next){
  res.locals.user = req.user;
  next();
});

routes(app);

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

module.exports = app;