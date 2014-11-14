module.exports = (app, model) ->
  app.route('/recipes/:slug')
      .get (req, res) ->
        title = "CookMii - #{req.params.slug}"
        res.render 'recipes/show',
          title: title
