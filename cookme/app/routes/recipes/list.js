module.exports = function (app) {

  var Recipe = app.locals.Recipe;
  app.route('/recipes')
    .get(function (req, res){
      Recipe.model.find( {} , function (err, recipes){
        if(err)
          res.send(err);
        res.render('recipes/index', {
          recipes: recipes
        });
      });
    });

}