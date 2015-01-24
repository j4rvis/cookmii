Recipe = require '../models/Recipe'
_ = require 'lodash'

class RecipeCtrl extends require './BaseCtrl'
  constructor: ->

  slugify: (text)->
    super text

  slugify_unique: (text)->
    super text

  create: (req,res) =>
    ingredients = req.body.ingredients;
    categories = req.body.categories;
    recipe = new Recipe
      name: req.body.name
      slug: @slugify_unique(req.body.name)
      manual: req.body.manual
      isPublic: if req.body.isPublic is 'on' then true else false
      author: res.locals.user.username
      image: req.body.image_url if req.body.image_url? then ''

    if ingredients.name isnt ''
      for value, index in ingredients.name when value isnt ''
        recipe.ingredients.push
          name: ingredients.name[index]
          slug: @slugify(ingredients.name[index])
          quantity: ingredients.quantity[index]
          unit: ingredients.unit[index] unless ingredients.quantity[index] is ''

    if categories.name isnt ''
      for value in categories.name when value isnt ''
          recipe.categories.push
            name: value
            slug: @slugify(value)

    recipe.save (err, result) ->
      if err then res.send(err) else res.redirect(result.slug)

  update: (req,res) =>
    Recipe.findOne
      slug: req.params.slug
    ,(err, recipe) =>
      ingredients = req.body.ingredients
      categories = req.body.categories

      recipe.name = req.body.name
      recipe.slug = @slugify_unique(req.body.name)
      recipe.manual = req.body.manual
      recipe.isPublic = if req.body.isPublic is 'on' then true else false
      recipe.image = if req.body.image_url? then req.body.image_url else ''

      recipe.ingredients.pop() while recipe.ingredients.length
      recipe.categories.pop() while recipe.categories.length

      if ingredients.name isnt ''
        for value, index in ingredients.name when value isnt ''
          recipe.ingredients.push
            name: ingredients.name[index]
            slug: @slugify(ingredients.name[index])
            quantity: ingredients.quantity[index]
            unit: ingredients.unit[index] unless ingredients.quantity[index] is ''
      if categories.name isnt ''
        for value in categories.name when value isnt ''
            recipe.categories.push
              name: value
              slug: @slugify(value)
      recipe.save (err, result) ->
        console.log result
        if err then res.send(err) else res.redirect("/recipes/#{result.slug}")

  delete: (req,res) =>
    Recipe.model.remove
      slug: req.params.slug
    ,(err, recipe) ->
      if (err) then res.send(err)
      res.send if recipe is 1 then { msg: '' } else { msg:'error: ' + err }
  render: (req,res) =>
    Recipe.findOne
      "slug": req.params.slug
    ,(err, recipe) ->
      if err then res.send(err)
      recipe.bestFromAuthor (bestFromAuthor) ->
        res.render 'recipes/show',
          recipe: recipe
          bestFromAuthor: bestFromAuthor

  render_all: (req,res) =>
    Recipe.find
      'isPublic': true
    ,(err, recipes) =>
      if err then res.send(err)
      res.render 'recipes/index',
        recipes: recipes

  render_create: (req,res) =>
    res.render 'recipes/new'

  render_update: (req,res) =>
    Recipe.findOne
      'slug': req.params.slug
    ,(err, recipe) ->
      res.render 'recipes/edit',
        recipe: recipe

  render_own: (req,res) =>
    Recipe.find
      'author': res.locals.user.username
    ,(err, recipes) ->
      res.render 'recipes/index',
        recipes: recipes

module.exports = RecipeCtrl