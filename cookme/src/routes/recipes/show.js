(function() {
  module.exports = function(app, model) {
    return app.route('/recipes/:slug').get(function(req, res) {
      var title;
      title = "CookMii - " + req.params.slug;
      return res.render('recipes/show', {
        title: title
      });
    });
  };

}).call(this);
