Recipe = require '../models/Recipe'
User = require '../models/User'
Party = require '../models/Party'

module.exports =
  isLoggedIn: (req, res, next) ->
    if req.isAuthenticated() then return next() else res.redirect('/')

  isAuthor: (req, res, next) =>
    if res.locals.user
      Recipe.findOne
        'slug': req.params.slug
        'author': res.locals.user.username
      .exec (err, recipe) ->
        if recipe then return next() else res.redirect('/recipes')
    else
      res.redirect('/recipes')

  isOwner: (req, res, next) =>
    if res.locals.user
      Party.findOne
        'slug': req.params.party
        '_owner': res.locals.user._id
      .exec (err, recipe) ->
        if recipe then return next() else res.redirect('/')
    else
      res.redirect('/')

  isPublic: (req, res, next) =>
    if res.locals.user
      Recipe.findOne
        slug: req.params.slug
        $or: [
          {isPublic: true}
          {author:res.locals.user.username}
        ]
      .exec (err, recipe) ->
          if recipe then return next() else res.redirect('/recipes')
    else
      Recipe.findOne
        'slug': req.params.slug
        'isPublic': true
      .exec (err, recipe) ->
        if recipe then return next() else res.redirect('/recipes')
