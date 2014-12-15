module.exports = function(app, passport) {

  var passport = app.locals.passport;
  app.route('/signup')
    .get(function (req, res) {
      res.render('users/signup', { message: req.flash('signupMessage') });
    })
    .post(passport.authenticate('local-signup', {
      failureRedirect : '/signup',
      failureFlash : true
    }), function (req, res){
        res.redirect("/"+req.user.local.username+"/profile");
      }
    );
}