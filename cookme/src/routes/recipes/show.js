(function() {
  module.exports = function(app, Recipe) {
    return app.route('/recipes/:slug').get(function(req, res) {
      Recipe.model.findOne({
        "slug": req.params.slug
      });
      return function(err, recipe) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/show', {
          recipe: recipe
        });
      };
    });
  };

}).call(this);
