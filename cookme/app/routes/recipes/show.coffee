module.exports = (app, Recipe) ->
  app.route('/recipes/:slug')
    .get (req, res) ->
      Recipe.model.findOne "slug": req.params.slug
      (err, recipe) ->
        if(err)
          res.send(err)
        res.render 'recipes/show',
          recipe: recipe

  # Controller Settings
  #
  # app.route('/recipes/:slug')
  #   .get (req, res) ->
  #     Recipe.findOne req.params.slug, (err, recipe) ->
  #       if(err)
  #         res.send(err)
  #       res.render 'recipes/show',
  #         recipe: recipe
