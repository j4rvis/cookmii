module.exports = (app, model) ->
  app.route('/recipes/new')
    .get (req, res) ->
      console.log "new"
      res.render 'recipes/new',
        title: "CookMii - New Recipe"
    .post (req, res) ->
      console.log req.body.name
      console.log req.body.manual
      console.log req.body.email
      res.redirect 'recipes/new',
        title: "CookMii - New Recipe"
  