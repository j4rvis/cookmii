(function() {
  module.exports = function(app) {
    var Recipe;
    Recipe = require('../../models/recipes');
    require('./list')(app, Recipe);
    require('./create')(app, Recipe);
    require('./show')(app, Recipe);
    return require('./delete')(app, Recipe);
  };

}).call(this);
