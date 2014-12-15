module.exports = function (app) {

  var Recipe = app.locals.Recipe;
  app.route('/recipes/:slug/:user')
    .post(Recipe.isPublic, function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        recipe.isFavorite(req.params.user);
        // if(recipe.isFavorite(req.params.user)){
        //   recipe.favorites.pop({user: req.params.user});
        // } else {
        //   recipe.favorites.push({user: req.params.user});
        // }
        // recipe.save(function(err, result){
        //   if (err)
        //     res.send(err);
        //   res.send(recipe.isFavorite(req.params.user));
        // });
      });
    });

  app.route('/recipes/:slug/favcount')
    .get(Recipe.isPublic, function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        res.send(""+recipe.favorites.length);
      });
    });
}