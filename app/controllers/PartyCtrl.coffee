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
    .populate '_owner attendees._user', 'username'
    .exec (err, result) ->
      console.log result, result.attendees
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

    User.find
      username:
        $in:
          req.body.attendees

    .exec (err, users) ->

      _.each _.pluck(users, '_id'), (id)->
        party.attendees.push {_user: id}
      # party.attendees._user = _.pluck(users, '_id')
      party.save (err, result) ->
        console.log result
        res.redirect "/parties/#{result.slug}"

  update: (req, res) =>

  delete: (req, res) =>

  add_recipe: (req, res) =>

  remove_recipe: (req, res) =>


module.exports = PartyCtrl
