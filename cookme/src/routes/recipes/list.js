(function() {
  module.exports = function(app, Recipe) {
    app.route('/recipes').get(function(req, res) {
      return Recipe.find({
        'public': true
      }, function(err, recipes) {
        if (err) {
          res.send(err);
        }
        return res.render('recipes/index', {
          recipes: recipes
        });
      });
    });
    app.route('/myrecipes').get(function(req, res) {
      Recipe.find({
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
      Recipe.find({
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
