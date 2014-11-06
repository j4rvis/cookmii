module.exports = (app)->

  Recipe = require '../models/recipes'
  
  app.route('/')
  .get (req, res) ->
    res.render 'recipes/index',
      title: 'CookMii - Recipes'

  app.route('/recipes/new')
  .get (req, res) ->
    res.render 'recipes/new',
      title: "CookMii - New Recipe"
  .post (req, res) ->
    console.log req.body.name
    console.log req.body.manual
    console.log req.body.email
    res.redirect 'recipes/new',
      title: "CookMii - New Recipe"
      
  app.route('/recipes/:slug')
  .get (req, res) ->
    title = "CookMii - #{req.params.slug}"
    res.render 'recipes/show',
      title: title
