module.exports = (app, Recipe) ->
  app.route('/recipes')
    .get (req, res) ->
      Recipe.findAll (err, recipes) ->
        if (err)
          res.send(err)

        res.render 'recipes/index',
          items: recipes

      # model.find 'public':true,(err, recipes) ->
      #   if (err)
      #     res.send(err)

      #   res.render 'recipes/index',
      #     items: recipes
