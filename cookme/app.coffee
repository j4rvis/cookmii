express = require "express"
path = require "path"
favicon = require "static-favicon"
logger = require "morgan"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
methodOverride  = require 'method-override'
Promise = require "bluebird"
mongoose = require 'mongoose'
passport = require 'passport'
session = require 'express-session'
flash = require 'connect-flash'

routes = require "./app/routes"
app = express()

require('./app/config/passport')(passport)
mongoose.connect 'mongodb://localhost:27017/cookmii_test'

app.locals.UserModel = require("./app/models/users")
app.locals.RecipeModel = require("./app/models/recipes")
# view engine setup
app.set "views", path.join(__dirname, "app/views")
app.set "view engine", "jade"
app.use favicon()
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use methodOverride()
app.use express.static(path.join(__dirname, "public"))
app.use session
  secret: 'ilovetullamore'
  saveUninitialized: true
  resave: true
app.use passport.initialize()
app.use passport.session()
app.use flash()

app.use (req, res, next) ->
  res.locals.user = req.user
  next()

routes(app, passport)

#/ catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return


#/ error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

module.exports = app
