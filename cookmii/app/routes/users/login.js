module.exports = function(app, passport) {

  var passport = app.locals.passport;
  app.route('/login')
    .get(function (req, res) {
      res.render('users/login', { message: req.flash('loginMessage') });
    })
    .post(passport.authenticate('local-login', {
        failureRedirect : '/login',
        failureFlash : true
      }), function (req, res){
        res.redirect("/"+req.user.local.username+"/profile");
      }
    );
}