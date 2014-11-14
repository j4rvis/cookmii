(function() {
  module.exports = function(app) {
    var Recipe;
    Recipe = require('../../controller/RecipeController');
    require('./list')(app, Recipe);
    require('./create')(app, Recipe);
    require('./show')(app, Recipe);
    return require('./delete')(app, Recipe);
  };

}).call(this);
