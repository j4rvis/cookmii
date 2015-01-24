Recipe = require '../models/Recipe'
User = require '../models/User'

module.exports =
  isLoggedIn: (req, res, next) ->
    if req.isAuthenticated then return next() else res.redirect('/')

  isAuthor: (req, res, next) =>
    if res.locals.user
      Recipe.findOne
        'slug': req.params.slug
        'author': res.locals.user.username
      , (err, recipe) ->
        if recipe then return next() else res.redirect('/recipes')
    else
      res.redirect('/recipes')

  isPublic: (req, res, next) =>
    if res.locals.user
      Recipe.findOne
        slug: req.params.slug
        $or: [
          {isPublic: true}
          {author:res.locals.user.username}
        ]
      ,(err, recipe) ->
          if recipe then return next() else res.redirect('/recipes')
    else
      Recipe.findOne
        'slug': req.params.slug
        'isPublic': true
      , (err, recipe) ->
        if recipe then return next() else res.redirect('/recipes')
