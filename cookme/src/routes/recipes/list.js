(function() {
  module.exports = function(app, Recipe) {
    app.route('/recipes').get(function(req, res) {
      return Recipe.model.find({}, function(err, recipes) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/index', {
          recipes: recipes
        });
      });
    });
    app.route('/myrecipes').get(function(req, res) {
      Recipe.model.find({
        'author': res.locals.user.local.username
      });
      return function(err, recipes) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/index', {
          recipes: recipes
        });
      };
    });
    return app.route('/favorites').get(function(req, res) {
      Recipe.model.find({
        'favorites.user': res.locals.user.local.username
      });
      return function(err, recipes) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/index', {
          recipes: recipes
        });
      };
    });
  };

}).call(this);
