(function() {
  module.exports = function(app, model) {
    return app.route('/recipes/new').get(function(req, res) {
      console.log("new");
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
  };

}).call(this);
