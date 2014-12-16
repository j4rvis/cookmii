module.exports = function (app) {

  var Recipe = app.locals.Recipe;
  var User = app.locals.UserModel;

  app.route('/recipes/:slug/favcount')
    .get(Recipe.isPublic, function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        res.send(''+recipe.favCount);
      });
    });
  app.route('/recipes/:slug/:user')
    .post(Recipe.isPublic, function (req, res){
      Recipe.model.findOne({"slug": req.params.slug}, function (err, recipe){
        if(err)
          res.send(err);
        recipe.isFavorite(req.params.user, function(result){
          if(result)
            recipe.favorites.pop({user: req.params.user});
          else
            recipe.favorites.push({user: req.params.user});
          recipe.save(function(err, recipe){
            if (err)
              res.send(err);

            User.findOne({'local.username': req.params.user},function(err, user){
              Recipe.model.find({'favorites.user': user.local.username}, function(err, number){
                user.local.favorites=number.length;
                user.save(function(err, user){
                  if (err)
                    res.send(err);
                  res.send(""+result);
                });

              });
            });
          });

        });
      });
    })
    .get(Recipe.isLoggedIn, function(req, res){
      Recipe.model.findOne({slug: req.params.slug}, function (err, recipe) {
        if(err)
          res.send(err);
        recipe.isFavorite(req.params.user, function(result){
          if(result)
            res.send(true);
          else
            res.send(false);
        });
      });
    });

}