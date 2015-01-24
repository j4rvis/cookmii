mongoose = require ('mongoose')
async = require ('async')
fs = require ('fs')
_ = require 'lodash'
loremIpsum = require('lorem-ipsum')
Recipe = require("../app/models/Recipe")
User = require("../app/models/User")
files = [
  "#{__dirname}/ressources/categories.txt"
  "#{__dirname}/ressources/ingredient_units.txt"
  "#{__dirname}/ressources/ingredients.txt"
  "#{__dirname}/ressources/recipe_names.txt"
  "#{__dirname}/ressources/recipe_images.txt"
]
categories = []
ingredient_units = []
ingredients = []
recipe_names = []
recipe_images = []

mongoose.connect('mongodb://localhost:27017/cookmii_test')
# mongoose.connect('mongodb://j4rvis:dbtest@ds029911.mongolab.com:29911/production')
# numberOfRecipes = process.argv[3]
validUsers = []

if mongoose.connection.readyState is 2
  console.log("Connection established!")

async.series([
  (callback) =>
    User.find {}, (err, _users) ->
      if err then throw err
      if !_users?
        console.log('No user found with this username')
      else
        async.eachSeries _users, populateUsers, (err) ->
          console.log("Populated "+validUsers.length+" User")
          callback()
  (callback) =>
    fs.readFile files[0], 'utf8', (err, data) ->
      categories = data.split("\n")
      callback()
  (callback) =>
    fs.readFile files[1], 'utf8', (err, data) ->
      ingredient_units = data.split("\n")
      callback()
  (callback) =>
    fs.readFile files[2], 'utf8', (err, data) ->
      ingredients = data.split("\n")
      callback()
  (callback) =>
    fs.readFile files[3], 'utf8', (err, data) ->
      recipe_names = data.split("\n")
      callback()
  (callback) =>
    fs.readFile files[4], 'utf8', (err, data) ->
      recipe_images = data.split("\n")
      callback()
  (callback) ->
    async.eachSeries validUsers, populateRecipe, (err) ->
      callback()
  (callback) ->
    console.log('Hooooray')
    process.exit(1)
])

slugify = (text) ->
  tr = {"ä":"ae", "ü":"ue", "ö":"oe", "ß":"ss" }
  return text.toString().toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[äöüß]/g, ($0)-> tr[$0])
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '')

slugify_unique = (text) ->
  return "#{slugify(text)}#{new Date().getTime()}"

populateUsers = (_user, doneCallback) ->
  if _user.username?
    validUsers.push(_user.username)
  doneCallback(null)

randomElement = (length) ->
  _.random 0, length

populateRecipe = (_user, doneCallback) =>
  r_names = _.shuffle recipe_names
  i_names = _.shuffle ingredients
  c_names = _.shuffle categories
  recipe = new Recipe()
  name = r_names.pop()
  recipe.name = name
  recipe.slug = slugify_unique(name)
  recipe.manual = loremIpsum
   count: _.random 1, 200
   units: 'words'
  recipe.isPublic = ['true','false'][Math.round(Math.random())]
  recipe.author = _user
  recipe.image = recipe_images[randomElement(recipe_images.length-1)]

  async.series [
    (callback) =>
      limit = _.random 0, 10
      _([0..limit]).forEach (num) =>
        ingr_name = i_names.pop()
        recipe.ingredients.push
          name: ingr_name
          slug: slugify(ingr_name)
          quantity: _.random 1, 1000
          unit: ingredient_units[randomElement(ingredient_units.length-1)]
        callback() if num is limit
    (callback) =>
      limit = _.random 0, 5
      _([0..limit]).forEach (num) =>
        cat_name = c_names.pop()
        recipe.categories.push
          name: cat_name
          slug: slugify(cat_name)
        callback() if num is limit
    (callback) =>
      recipe.save (err, result) ->
        if err then throw err
        console.log("Added a recipe to the user " + _user)
        return doneCallback(null)
  ]