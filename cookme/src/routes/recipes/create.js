(function() {
  module.exports = function(app, Recipe) {
    var fs, multipart, multipartMiddleware;
    fs = require('fs');
    multipart = require('connect-multiparty');
    multipartMiddleware = multipart({
      uploadDir: __dirname + "/../../../public/uploads"
    });
    return app.route('/recipes/new').get(function(req, res) {
      return res.render('recipes/new', {
        title: "CookMii - New Recipe"
      });
    }).post(multipartMiddleware, function(req, res) {
      var image_path, key, recipe, target_path, tmp_path;
      recipe = new Recipe.model(req.body);
      recipe.slug = Recipe.slugify(req.body.name);
      tmp_path = req.files.image.path;
      target_path = __dirname + "/../../../public/uploads/" + recipe.slug + '.jpg';
      image_path = "../uploads/" + recipe.slug + '.jpg';
      fs.rename(tmp_path, target_path, function(err) {
        if (err) {
          throw err;
        }
        return fs.unlink(tmp_path, function() {
          if (err) {
            throw err;
          }
          return console.log('uploaded');
        });
      });
      recipe.image = image_path;
      for (key in req.body.ingredients.name) {
        if (req.body.ingredients.name[key] !== '' && req.body.ingredients.quantity[key] !== '') {
          recipe.ingredients.push({
            name: req.body.ingredients.name[key],
            quantity: req.body.ingredients.quantity[key],
            unit: req.body.ingredients.unit[key]
          });
        }
      }
      for (key in req.body.categories.name) {
        if (req.body.categories.name[key] !== '') {
          recipe.categories.push({
            name: req.body.categories.name[key]
          });
        }
      }
      return recipe.save(function(err, result) {
        if (err) {
          res.send(err);
        }
        return res.redirect(result.slug);
      });
    });
  };

}).call(this);
