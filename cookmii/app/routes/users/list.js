module.exports = function(app, passport) {

  var passport = app.locals.passport;
  var User = app.locals.UserModel;
  app.route('/users')
    .get(passport.isLoggedIn, function (req, res){
      User.find( {} , function (err, users){
        if(err)
          res.send(err);
        res.render('users/index', {
          users: users
        });
      });
    });

}