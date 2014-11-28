module.exports = function(app, passport) {

  app.route('/login')
    .get(function (req, res) {
      res.render('users/login', { message: req.flash('loginMessage') });
    })
    .post(passport.authenticate('local-login', {
      successRedirect : '/profile',
      failureRedirect : '/login',
      failureFlash : true
    }));
}