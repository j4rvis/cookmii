module.exports = function(app){
  require('./users')(app);
  require('./recipes')(app);

  var Recipe = app.locals.Recipe;

  app.route('/').get(function (req, res){
    Recipe.model.aggregate(
      {$unwind: '$ingredients'},
      {$group : {_id : "$ingredients.name", count : {$sum : 1}}},
      {$sort:{count:-1}},
      {$limit: 10},
      function(err, ingredients){
        res.render('index',{
          ingredients:ingredients
        });
      }
    );
  });

  app.route('/').get(function (req, res){
    res.redirect('/recipes');
  });
}