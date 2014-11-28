module.exports = function (app){

  var Recipe = app.locals.Recipe;
  var fs = require('fs');
  var multipart = require('connect-multiparty');
  var multipartMiddleware = multipart({uploadDir: __dirname + "/../../../public/uploads"});

  app.route('/recipes/:slug/edit')
    .get( Recipe.isAuthor, function (req, res){
      Recipe.model.findOne({'slug': req.params.slug}, function (err, recipe){
        res.render('recipes/edit',{
          recipe: recipe,
          title: "CookMii - Edit " + recipe.name
        });
      });
    })
    .post(multipartMiddleware, function (req, res){
      Recipe.model.findOne({slug: req.params.slug}, function (err, recipe){
        var ingredients = req.body.ingredients;
        var categories = req.body.categories;

        recipe.name = req.body.name;
        recipe.slug = Recipe.slugify(req.body.name);
        recipe.manual = req.body.manual;
        recipe.isPublic = typeof req.body.isPublic !== 'undefined' && req.body.isPublic==='on' ? true : false;

        if(req.files.image.size > 0){
          var tmp_path = req.files.image.path;
          var target_path = __dirname + "/../../../public/uploads/" + recipe.slug + '.jpg';
          var image_path = "../uploads/" + recipe.slug + '.jpg';
          fs.rename(tmp_path, target_path, function(err){
            if(err)
              throw err;
            fs.unlink(tmp_path,function(){
              if(err)
                throw err;
            });
          });
          recipe.image = image_path;
        }
        while(recipe.ingredients.length){
          recipe.ingredients.pop();
        }
        if(typeof ingredients !== 'undefined' && ingredients.name !== ''){
          if(ingredients.name instanceof Array){
            ingredients.name.forEach(function(value, key){
              if(value != ""
                && typeof ingredients.quantity[key] !== 'undefined'
                && ingredients.quantity[key] !== ""){

                recipe.ingredients.push({
                  name: ingredients.name[key],
                  quantity: parseInt(ingredients.quantity[key]),
                  unit: ingredients.unit[key]
                });
              }
            });
          } else {
            if(typeof ingredients.quantity !== 'undefined'
              && ingredients.quantity !== ""){

              recipe.ingredients.push({
                name: ingredients.name,
                quantity: ingredients.quantity,
                unit: ingredients.unit
              });
            }
          }
        }
        while(recipe.categories.length){
          recipe.categories.pop();
        }
        if(typeof categories !== 'undefined' && categories.name != ''){
          if(categories.name instanceof Array){
            categories.name.forEach(function(value, key){
              recipe.categories.push({
                name: categories.name[key]
              });
            });
          } else{
            recipe.categories.push({
              name: categories.name
            });
          }
        }
        recipe.save(function (err, result) {
          if (err)
            res.send(err)
          res.redirect('/recipes/'+result.slug);
        });
      });
    });
}
