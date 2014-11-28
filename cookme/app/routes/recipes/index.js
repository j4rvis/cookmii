module.exports = function(app){
  // Recipe = require '../../controller/RecipeController'
  var Recipe = {
    model: app.locals.RecipeModel,
    slugify: function(text){
      var tr = {"ä":"ae", "ü":"ue", "ö":"oe", "ß":"ss" };
      var text = text.toString().toLowerCase()
        .replace(/\s+/g, '-')
        .replace(/[äöüß]/g, function($0){ return tr[$0]})
        .replace(/[^\w\-]+/g, '')
        .replace(/\-\-+/g, '-')
        .replace(/^-+/, '')
        .replace(/-+$/, '');
      return text + '_' + new Date().getTime();
    }

  }
  require('./list')( app, Recipe);
  require('./create')( app, Recipe);
  require('./show')( app, Recipe);
  require('./edit')( app, Recipe);
  // require('./delete')( app, Recipe);
}
