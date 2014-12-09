var mongoose = require ('mongoose');
var async = require ('async');
var fs = require ('fs');
var loremIpsum = require('lorem-ipsum');
var Recipe = require("./app/controller/RecipeController");
var User = require("./app/models/User");
var files = [
  "./app/factory/categories.txt",
  "./app/factory/ingredient_units.txt",
  "./app/factory/ingredients.txt",
  "./app/factory/recipe_names.txt"
]
var categories = [];
var ingredient_units = [];
var ingredients = [];
var recipe_names = [];

mongoose.connect('mongodb://localhost:27017/cookmii_test');
var numberOfRecipes = process.argv[3];
var validUsers = [];

if(mongoose.connection.readyState === 2)
  console.log("Connection established!");

var populateUsers = function(_user, doneCallback) {
  if(_user.local.username !== undefined){
    validUsers.push(_user.local.username);
  }
  return doneCallback(null);
}

var randomElement = function(length){
  return Math.floor(Math.random()* length)
}

var populateRecipe = function(_user, doneCallback) {
  // var inserted = 1;
  // var random = Math.floor(Math.random() * 5) + 1;
  // for(var i = 1; i <= random; i++) {

  var recipe = new Recipe.model();
  recipe.name = recipe_names[randomElement(recipe_names.length)];
  recipe.slug = Recipe.slugify(recipe.name);
  recipe.manual = output = loremIpsum({ count: Math.floor(Math.random() * 500) + 1 });
  recipe.isPublic = ['true','false'][Math.round(Math.random())];
  recipe.author = _user;
  recipe.image = "http://lorempixel.com/640/480/food/";

  for (var ing = 0; ing <= Math.floor(Math.random() * 20) + 1 ; ing++) {
    recipe.ingredients.push({
      name: ingredients[randomElement(ingredients.length)],
      quantity: Math.floor(Math.random() * 1000) + 1,
      unit: ingredient_units[randomElement(ingredient_units.length)]
    });
  };
  for (var cat = 0; cat <= Math.floor(Math.random() * 10) + 1 ; cat++) {
    recipe.categories.push({
      name: categories[randomElement(categories.length)]
    });
  };
  recipe.save(function (err, result) {
    if (err)
      res.send(err)
    console.log("Added a recipe to the user " + _user)
    return doneCallback(null);
  });
}

async.series([
  function(callback){
    User.find({}, function(err, _users){
      if(err)
        throw err;
      if(_users===null)
        console.log('No user found with this username');
      else{
        async.each(_users, populateUsers, function(err){
          console.log("Populated "+validUsers.length+" User");
          callback();
        });
      }
    });
  },
  function(callback){
    fs.readFile(files[0], 'utf8', function (err, data){
      categories = data.split(";\n");
      callback();
    });
  },
  function(callback){
    fs.readFile(files[1], 'utf8', function (err, data){
      ingredient_units = data.split(";\n");
      callback();
    });
  },
  function(callback){
    fs.readFile(files[2], 'utf8', function (err, data){
      ingredients = data.split(";\n");
      callback();
    });
  },
  function(callback){
    fs.readFile(files[3], 'utf8', function (err, data){
      recipe_names = data.split(";\n");
      callback();
    });
  },
  function(callback){
    async.each(validUsers, populateRecipe, function(err){
      callback();
    });
  },
  function(callback){
    console.log('Hooooray');
    process.exit(1);
  }
]);

