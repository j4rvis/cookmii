LocalStrategy   = require('passport-local').Strategy
# load up the user model
User = require '../models/User'

module.exports = (passport) ->

  #
  # passport session setup
  #
  # required for persistent login sessions
  # passport needs ability to serialize and unserialize users out of session

  # used to serialize the user for the session
  passport.serializeUser (user, done) ->
    done(null, user.id)

  # used to deserialize the user
  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done(err, user)

  #
  # LOCAL SIGNUP
  #

  passport.use 'local-signup', new LocalStrategy
    usernameField : 'email'
    passwordField : 'password'
    passReqToCallback : true
    , (req, email, password, done) ->
      process.nextTick () ->
        User.findOne
          $or:[
            {'email' :  email}
            {'username': req.body.username}
          ]
          (err, user) ->
            if err then return done(err)
            if user
              return done(null, false, req.flash('signupMessage', 'That email or username are already taken.'))
            else
              newUser = new User()
              newUser.username = req.body.username
              newUser.email    = email
              newUser.password = newUser.generateHash(password)
              newUser.save (err) ->
                if err
                  console.log("Error")
                  throw err
                console.log("Success")
                return done(null, newUser)

  #
  # LOCAL LOGIN
  #
  passport.use 'local-login', new LocalStrategy
    usernameField : 'username'
    passwordField : 'password'
    passReqToCallback : true
  , (req, username, password, done) ->
    User.findOne
      'username': username
    , (err, user) ->
      if err then return done(err)
      unless user then return done(null, false, req.flash('loginMessage', 'No user found.'))
      unless user.validPassword(password)
        return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.'))
      return done(null, user)
