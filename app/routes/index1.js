module.exports = function(app){
  require('./users')(app);
  require('./recipes')(app);
  require('./search')(app);
  var async = require("async");

  var Recipe = app.locals.Recipe;

  app.route('/').get(function (req, res){
    var categories;
    var ingredients;
    var bestRecipes;
    async.parallel([
      function(callback){
        Recipe.model.aggregate(
          {$unwind: '$ingredients'},
          {$group : {_id : "$ingredients.name", count : {$sum : 1}}},
          {$sort:{count:-1}},
          {$limit: 10},
          function(err, ingr){
            if(err)
              callback(err);
            ingredients = ingr;
            callback();
          }
        );
      },
      function(callback){
        Recipe.model.aggregate(
          {$unwind: '$categories'},
          {$group : {_id : "$categories.name", count : {$sum : 1}}},
          {$sort:{count:-1}},
          {$limit: 10},
          function(err, cat){
            if(err)
              callback(err);
            categories = cat;
            callback();
          }
        );
      },
      function(callback){
        // WHY __v ???
        Recipe.model
        .find({isPublic:true})
        .sort({__v:-1})
        .limit(5)
        .exec(function(err,best){
          if(err)
            throw err;
          bestRecipes = best;
          callback();
        });
      }
    ],
    function(err){
      if(err)
        throw err;
      res.render('index',{
        ingredients: ingredients,
        categories: categories,
        bestRecipes: bestRecipes
      });
    });
  });
}