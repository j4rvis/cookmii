Recipe = require '../models/Recipe'
Party = require '../models/Party'
User = require '../models/User'
_ = require 'lodash'
# async = require 'async'

class PartyCtrl extends require './BaseCtrl'

  slugify_unique: (text)->
    super text

  render: (req, res) =>
    Party.findOne
      slug: req.params.party
      $or: [
        {_owner: res.locals.user._id}
        {'attendees._user._id': res.locals.user._id}
      ]
    .populate '_owner attendees._user', 'username'
    .exec (err, result) ->
      res.render 'parties/show',
        party: result
  render_all: (req, res) =>
    Party.find
      $or: [
        {_owner: res.locals.user._id}
        {'attendees._user._id': res.locals.user._id}
      ]
    .populate '_owner attendees._user', 'username'
    .exec (err, results) ->
      res.render 'parties/index',
      parties: results
  render_create: (req, res) =>
    res.render 'parties/new'

  render_update: (req, res) =>

  create: (req, res) =>
    party = new Party
      name: req.body.name
      slug: @slugify_unique(req.body.name)
      description: req.body.description
      _owner: res.locals.user._id
      date: req.body.date
      time: req.body.time

    attendees = req.body.attendees
    attendees = if _.isArray attendees then attendees else [attendees]
    User.find
      username:
        $in:
          attendees
    .exec (err, users) ->
      console.log users
      users = _.pluck(users, '_id')
      console.log _.isArray users
      if _.isArray users
        _.each users, (id)->
          party.attendees.push {_user: id}
      party.save (err, result) ->
        console.log result
        res.redirect "/parties/#{result.slug}"

  update: (req, res) =>

  delete: (req, res) =>

  add_recipe: (req, res) =>

  remove_recipe: (req, res) =>


module.exports = PartyCtrl
