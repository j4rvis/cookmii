module.exports = function (app) {

  var Recipe = app.locals.Recipe;
  app.route('/recipes/:slug')
    .get(Recipe.isPublic, function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        recipe.bestFromAuthor(function(bestFromAuthor){
          res.render('recipes/show', {
            recipe: recipe,
            bestFromAuthor: bestFromAuthor
          });
        });
      });
    });
}