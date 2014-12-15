module.exports = function(app){


  var passport = app.locals.passport;
  passport.isLoggedIn = function(req, res, next) {
    if (req.isAuthenticated())
      return next();
    res.redirect('/');
  }

  require('./login')(app);
  require('./signup')(app);
  require('./logout')(app);
  require('./profile')(app);
  require('./list')(app);
}