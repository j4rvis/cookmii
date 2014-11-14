module.exports = (app) ->
  
  Recipe = require '../../controller/RecipeController'

  require('./list')( app, Recipe)
  require('./create')( app, Recipe)
  require('./show')( app, Recipe)
  require('./delete')( app, Recipe)