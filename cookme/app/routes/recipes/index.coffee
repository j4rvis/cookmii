module.exports = (app) ->

  # Recipe = require '../../controller/RecipeController'
  Recipe = require '../../models/recipes'

  require('./list')( app, Recipe)
  require('./create')( app, Recipe)
  require('./show')( app, Recipe)
  require('./delete')( app, Recipe)