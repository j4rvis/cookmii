module.exports = function(app, passport) {

  var passport = app.locals.passport;
  app.route('/profile')
    .get(passport.isLoggedIn, function (req, res, next) {
      res.render('users/profile', {
        user : req.user
      });
    });
}