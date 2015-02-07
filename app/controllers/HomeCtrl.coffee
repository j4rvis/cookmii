Recipe = require '../models/Recipe'
_ = require 'lodash'
async = require 'async'

class HomeCtrl extends require './BaseCtrl'
  render: (req, res) =>
    ingredients = ''
    categories = ''
    bestRecipes = ''
    async.parallel [
      (callback) ->
        Recipe.aggregate {$unwind: '$ingredients'},
          {$group :
            _id : "$ingredients.name"
            count :
              $sum : 1},
          {$sort:{count:-1}},
          {$limit: 10},
          (err, ingr) ->
            if err then return callback(err)
            ingredients = ingr
            return callback()
      (callback) ->
        Recipe.aggregate {$unwind: '$categories'},
          {$group :
            _id : "$categories.name"
            count :
              $sum : 1},
          {$sort:{count:-1}},
          {$limit: 10},
          (err, cat) ->
            if err then return callback(err)
            categories = cat
            return callback()
      (callback) ->
        Recipe.find
          isPublic:true
        .sort({__v:-1})
        .limit(5)
        .exec (err,best) ->
          if err then throw err
          bestRecipes = best
          return callback()
    ], (err) =>
      if err then throw err
      res.render 'index',
        ingredients: ingredients
        categories: categories
        bestRecipes: bestRecipes
  search: (req, res) =>
    Recipe.find
      'isPublic': true
      $or:[
        {'name': new RegExp(req.body.search, "i")}
        {'categories.name': new RegExp(req.body.search, "i")}
        {'ingredients.name': new RegExp(req.body.search, "i")}
      ]
    .exec (err, recipes) ->
      if err then res.send(err)
      res.render 'recipes/index',
        recipes: recipes

module.exports = HomeCtrl