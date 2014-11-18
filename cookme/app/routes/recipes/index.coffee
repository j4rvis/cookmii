module.exports = (app) ->

  # Recipe = require '../../controller/RecipeController'
  Recipe =
    model:
      require '../../models/recipes'
    slugify: (text) ->
      tr = {"ä":"ae", "ü":"ue", "ö":"oe", "ß":"ss" }
      text = text.toString().toLowerCase()
        .replace(/\s+/g, '-')         # Replace spaces with -
        .replace /[äöüß]/g
        , ($0) -> return tr[$0]       # Umlaute
        .replace(/[^\w\-]+/g, '')     # Remove all non-word chars
        .replace(/\-\-+/g, '-')       # Replace multiple - with single -
        .replace(/^-+/, '')           # Trim - from start of text
        .replace(/-+$/, '')
      date = new Date()
      return text+'_'+date.getTime()

  require('./list')( app, Recipe)
  require('./create')( app, Recipe)
  require('./show')( app, Recipe)
  require('./delete')( app, Recipe)