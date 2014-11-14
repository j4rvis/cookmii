(function() {
  module.exports = function(app, Recipe) {
    return app.route('/recipes').get(function(req, res) {
      return Recipe.findAll(function(err, recipes) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/index', {
          items: recipes
        });
      });
    });
  };

}).call(this);
