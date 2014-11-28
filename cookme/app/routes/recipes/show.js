module.exports = function (app, Recipe) {
  app.route('/recipes/:slug')
    .get(function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        res.render('recipes/show', {
          recipe: recipe
        });
      });
    });
}