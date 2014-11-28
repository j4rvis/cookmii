module.exports = function(app, passport) {
  // var User = app.get("UserModel");
  var User = app.locals.UserModel;
  app.route('/users')
    .get(function (req, res){
      User.find( {} , function (err, users){
        if(err)
          res.send(err);
        res.render('users/index', {
          users: users
        });
      });
    });

}