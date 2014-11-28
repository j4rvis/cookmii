var LocalStrategy   = require('passport-local').Strategy;
// load up the user model
var User = require('../models/User');

module.exports = function(passport) {

  // =========================================================================
  // passport session setup ==================================================
  // =========================================================================
  // required for persistent login sessions
  // passport needs ability to serialize and unserialize users out of session

  // used to serialize the user for the session
  passport.serializeUser(function(user, done) {
    done(null, user.id);
  });

  // used to deserialize the user
  passport.deserializeUser(function(id, done) {
    User.findById(id, function(err, user) {
      done(err, user);
    });
  });

  // =========================================================================
  // LOCAL SIGNUP ============================================================
  // =========================================================================

  passport.use('local-signup', new LocalStrategy({
    usernameField : 'email',
    passwordField : 'password',
    passReqToCallback : true
  },
  function(req, email, password, done) {
    process.nextTick(function() {
      User.findOne({$or:[
              { 'local.email' :  email },
              { 'local.username': req.body.username}]},
        function(err, user) {
          if (err)
            return done(err);
          if (user)
            return done(null, false, req.flash('signupMessage', 'That email or username are already taken.'));
          else {
            var newUser = new User();
            newUser.local.username = req.body.username;
            newUser.local.email    = email;
            newUser.local.password = newUser.generateHash(password);
            // console.log(req.body.profile_image)
            // newUser.local.profile_image = req.body.profile_image;

            newUser.save(function(err) {
              if (err){
                console.log("Error");
                throw err;
              }
              console.log("Success");
              return done(null, newUser);
            });
          }
        }
      );
    });
  }));

  // =========================================================================
  // LOCAL LOGIN =============================================================
  // =========================================================================
  passport.use('local-login', new LocalStrategy({
    usernameField : 'username',
    passwordField : 'password',
    passReqToCallback : true
  },
  function(req, username, password, done) {
    User.findOne({ 'local.username' :  username }, function(err, user) {
      if (err)
        return done(err);

      if (!user)
        return done(null, false, req.flash('loginMessage', 'No user found.'));

      if (!user.validPassword(password))
        return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.'));

      return done(null, user);
    });
  }));

};
