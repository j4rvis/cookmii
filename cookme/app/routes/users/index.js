module.exports = function(app, passport){

  passport.isLoggedIn = function(req, res, next) {
    if (req.isAuthenticated())
      return next();
    res.redirect('/');
  }

  require('./login')(app, passport);
  require('./signup')(app, passport);
  require('./logout')(app, passport);
  require('./profile')(app, passport);
  require('./list')(app, passport);
}