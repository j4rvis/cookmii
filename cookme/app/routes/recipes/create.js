module.exports = function (app){

  var Recipe = app.locals.Recipe;
  var fs = require('fs');
  var multipart = require('connect-multiparty');
  var multipartMiddleware = multipart({uploadDir: __dirname + "/../../../public/uploads"});

  app.route('/recipes/new')
    .get( function (req, res){
      res.render('recipes/new', {
        title: "CookMii - New Recipe"
      });
    })
    .post(Recipe.isLoggedIn, multipartMiddleware, function (req, res){
      var ingredients = req.body.ingredients;
      var categories = req.body.categories;
      var recipe = new Recipe.model();

      recipe.name = req.body.name;
      recipe.slug = Recipe.slugify(req.body.name);
      recipe.manual = req.body.manual;
      recipe.isPublic = typeof req.body.isPublic !== 'undefined' && req.body.isPublic==='on' ? true : false;
      recipe.author = res.locals.user.local.username;
      if(req.files.image.size > 0){
        var tmp_path = req.files.image.path;
        var target_path = __dirname + "/../../../public/uploads/" + recipe.slug + '.jpg';
        var image_path = "../uploads/" + recipe.slug + '.jpg';
        recipe.image = image_path;
        fs.rename(tmp_path, target_path, function(err){
          if(err)
            throw err;
          fs.unlink(tmp_path,function(){
            if(err)
              throw err;
          });
        });
      }
      if(ingredients.name !== ''){
        ingredients.name.forEach(function(value, key){
          if(value != ""
            && typeof ingredients.quantity[key] !== 'undefined'
            && ingredients.quantity[key] !== ""){

            recipe.ingredients.push({
              name: ingredients.name[key],
              quantity: ingredients.quantity[key],
              unit: ingredients.unit[key]
            });
          }
        });
      }

      if(categories.name != ''){
        categories.name.forEach(function(value, key){
          if(value != ""){
            recipe.categories.push({
              name: categories.name[key]
            });
          }
        });
      }
      recipe.save(function (err, result) {
        if (err)
          res.send(err)
        res.redirect(result.slug);
      });
    });
}
