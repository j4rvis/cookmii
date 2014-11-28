module.exports = function(app, passport) {

  app.route('/signup')
    .get(function (req, res) {
      res.render('users/signup', { message: req.flash('signupMessage') });
    })
    .post(passport.authenticate('local-signup', {
      successRedirect : '/profile',
      failureRedirect : '/signup',
      failureFlash : true
    }));
}