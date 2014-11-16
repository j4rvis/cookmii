module.exports = (app, Recipe) ->
  app.route('/recipes')
    .get (req, res) ->
      Recipe.find 'public':true, (err, recipes) ->
        if(err)
          res.send(err)
        res.render 'recipes/index',
          recipes: recipes

  app.route('/myrecipes')
    .get (req, res) ->
      Recipe.find 'author':res.locals.user.local.username
      (err, recipes) ->
        if(err)
          res.send(err)
        res.render 'recipes/index',
          recipes: recipes

  app.route('/favorites')
    .get (req, res) ->
      Recipe.find 'favorites.user':res.locals.user.local.username
      (err, recipes) ->
        if(err)
          res.send(err)
        res.render 'recipes/index',
          recipes: recipes