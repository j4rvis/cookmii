(function() {
  module.exports = function(app) {
    var Recipe;
    Recipe = require('../models/recipes');
    app.route('/').get(function(req, res) {
      return res.render('recipes/index', {
        title: 'CookMii - Recipes'
      });
    });
    app.route('/recipes/new').get(function(req, res) {
      return res.render('recipes/new', {
        title: "CookMii - New Recipe"
      });
    }).post(function(req, res) {
      console.log(req.body.name);
      console.log(req.body.manual);
      console.log(req.body.email);
      return res.redirect('recipes/new', {
        title: "CookMii - New Recipe"
      });
    });
    return app.route('/recipes/:slug').get(function(req, res) {
      var title;
      title = "CookMii - " + req.params.slug;
      return res.render('recipes/show', {
        title: title
      });
    });
  };

}).call(this);
