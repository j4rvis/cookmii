User = require '../models/User'
Recipe = require '../models/Recipe'
_ = require 'lodash'
passport = require 'passport'
require('../config/passport')(passport)

class UserCtrl extends require './BaseCtrl'
  constructor: ->
  slugify: (text)->
    super text
  login: (req, res, next) =>
    passport.authenticate('local-login',
      failureRedirect: '/login'
      failureFlash: true
    )(req, res, next)
  register: (req, res, next) =>
    passport.authenticate('local-signup',
      failureRedirect: '/register'
      failureFlash: true
    )(req, res, next)
  logout: (req, res) =>
    req.logout();
    res.redirect('/');
  render_register: (req, res) =>
    res.render 'users/register',
      message: req.flash('signupMessage')
  render_login: (req, res) =>
    res.render 'users/login',
      message: req.flash('loginMessage')
  redirect_profile: (req, res) =>
    res.redirect "/users/#{req.user.username}"
  render: (req, res) =>
    User.findOne
      'username': req.params.user
    .exec (err, user) ->
      if res.locals.user.username is req.params.user
        Recipe.find
          author: user.username
        .exec (err, recipes) ->
          res.render "users/profile",
            profile: user
            recipes: recipes
      else
        Recipe.find
          author: user.username
          isPublic: true
        .exec (err, recipes) ->
          res.render "users/profile",
            profile: user
            recipes: recipes
  render_all: (req, res) =>
    User.find {} , (err, users) ->
      if err then res.send(err)
      res.render 'users/index',
        users: users

  search: (req, res) =>
    User.find {'username': new RegExp(req.body.search, "i")}, 'username'
    .exec (err, result) ->
      excluded = []
      unless _.isEmpty req.body.excluded
        excluded.push req.body.excluded
      excluded.push res.locals.user.username
      result = _.filter result, (obj) =>
        return !_.contains(_.flatten(excluded), obj.username)
      if err then res.send(err) else res.send(result)


module.exports = UserCtrl