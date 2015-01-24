Recipe = require '../models/Recipe'
User = require '../models/User'
_ = require 'lodash'

class FavoriteCtrl extends require './BaseCtrl'
  render: (req, res) =>
    Recipe.find
      'favorites.user': res.locals.user.username
    ,(err, recipes) ->
      if err then res.send(err)
      res.render 'recipes/index',
        recipes: recipes
  get_fav_count: (req, res) =>
    Recipe.findOne
      "slug": req.params.slug
    ,(err, recipe) ->
      if err then res.send(err)
      res.send "#{recipe.favCount}"
  favorise: (req, res) =>
    Recipe.findOne
      "slug": req.params.slug
    ,(err, recipe) ->
      if err then res.send(err)
      recipe.isFavorite req.params.user ,(result) ->
        if result
          recipe.favorites.pop
            user: req.params.user
        else
          recipe.favorites.push
            user: req.params.user
        recipe.save (err, recipe) ->
          if err then res.send(err)
          User.findOne
            'username': req.params.user
          ,(err, user) ->
            Recipe.find
              'favorites.user': user.username
            ,(err, number) ->
              user.favorites=number.length
              user.save (err, user) ->
                if err then res.send(err)
                res.send result
  is_favorite: (req, res) =>
    Recipe.findOne
      slug: req.params.slug
    ,(err, recipe) ->
      if err then res.send(err)
      recipe.isFavorite req.params.user ,(result) ->
        res.send(result)

module.exports = FavoriteCtrl