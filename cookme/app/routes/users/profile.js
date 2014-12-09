module.exports = function(app, passport) {

  var User = app.locals.UserModel;
  var Recipe = app.locals.Recipe;
  var passport = app.locals.passport;
  app.route('/:user/profile')
    .get(function (req, res, next) {
      User.findOne({'local.username': req.params.user}, function(err, user){
        Recipe.model.find({author: user.local.username, isPublic: true}, function(err, recipes){
          res.render('users/profile', {
            profile: user,
            recipes: recipes
          });
        });
      });
    });
}