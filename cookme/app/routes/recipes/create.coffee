module.exports = (app, Recipe) ->

  fs = require 'fs'
  multipart = require 'connect-multiparty'
  multipartMiddleware = multipart uploadDir: __dirname + "/../../../public/uploads"

  app.route('/recipes/new')
    .get (req, res) ->
      res.render 'recipes/new',
        title: "CookMii - New Recipe"

    .post multipartMiddleware, (req, res) ->

      recipe = new Recipe.model(req.body)
      recipe.slug = Recipe.slugify(req.body.name);

      tmp_path = req.files.image.path
      target_path = __dirname + "/../../../public/uploads/" + recipe.slug + '.jpg'
      image_path = "../uploads/" + recipe.slug + '.jpg'
      fs.rename tmp_path, target_path, (err) ->
        if (err)
          throw err
        fs.unlink tmp_path, ->
          if (err)
            throw err
          console.log('uploaded')
      recipe.image = image_path

      for key of req.body.ingredients.name
        if req.body.ingredients.name[key]!='' and req.body.ingredients.quantity[key]!=''
          recipe.ingredients.push
            name: req.body.ingredients.name[key]
            quantity: req.body.ingredients.quantity[key]
            unit: req.body.ingredients.unit[key]

      for key of req.body.categories.name
        if req.body.categories.name[key]!=''
          recipe.categories.push
            name: req.body.categories.name[key]

      recipe.save (err, result) ->
        if (err)
          res.send(err)

        res.redirect(result.slug)



      # var recipe = new Recipe(req.body);


      # console.log(target_path, image_path);
      # fs.rename(tmp_path, target_path, function(err) {
      #   if (err) throw err;
      #   fs.unlink(tmp_path, function() {
      #     if (err) throw err;
      #     console.log('uploaded');
      #   });
      # });


      # for(var i = 0; i< req.body.ingr_name.length; i++){
      #   if(req.body.ingr_name[i]!=''){
      #     recipe.ingredients.push({
      #       name: req.body.ingr_name[i],
      #       quantity: req.body.ingr_quantity[i],
      #       unit: req.body.ingr_unit[i]
      #     });
      #   }
      # }

      # for(var i = 0; i< req.body.cat_name.length; i++){
      #   if(req.body.cat_name[i]!=''){
      #     recipe.categories.push({
      #       name: req.body.cat_name[i]
      #     });
      #   }
      # }

      # recipe.save(function(err, result) {
      #   if (err)
      #     res.send(err);

      #   res.redirect(result.slug);
      # });