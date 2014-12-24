module.exports= function(app){
  var Recipe = app.locals.Recipe;

  app.route('/search')
    .post(function(req, res) {
      Recipe.model.find({
        'isPublic': true,
        $or:[
          {'name': new RegExp(req.body.search, "i")},
          {'categories.name': new RegExp(req.body.search, "i")},
          {'ingredients.name': new RegExp(req.body.search, "i")}
        ]}, function(err, recipes) {
          if(err)
            res.send(err);

          console.log(recipes)

          res.render('recipes/index',{
            recipes: recipes
            // ,
            // search: req.body.search
          });
      });
    });
}