module.exports = function (app) {

  var Recipe = app.locals.Recipe;

  app.route('/recipes')
    .get(function (req, res){
      Recipe.model.find( {isPublic: true} , function (err, recipes){
        if(err)
          res.send(err);
        res.render('recipes/index', {
          recipes: recipes
        });
      });
    });
  app.route('/myrecipes')
    .get(Recipe.isLoggedIn, function (req, res){
      Recipe.model.find( {author: res.locals.user.local.username} , function (err, recipes){
        if(err)
          res.send(err);
        res.render('recipes/index', {
          recipes: recipes
        });
      });
    });
  app.route('/favorites')
    .get(Recipe.isLoggedIn, function (req, res){
      Recipe.model.find( {
        'favorites.user': res.locals.user.local.username
      }, function (err, recipes){
        if(err)
          res.send(err);
        res.render('recipes/index', {
          recipes: recipes
        });
      });
    });
}