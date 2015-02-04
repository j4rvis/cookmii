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
        {'attendees._user': res.locals.user._id}
      ]
    .populate '_owner attendees._user', 'username'
    .exec (err, result) ->
      res.render 'parties/show',
        party: result
  render_all: (req, res) =>
    Party.find
      $or: [
        {_owner: res.locals.user._id}
        {'attendees._user': res.locals.user._id}
      ]
    .populate '_owner attendees._user', 'username'
    .exec (err, results) ->
      res.render 'parties/index',
      parties: results
  render_create: (req, res) =>
    res.render 'parties/new'

  render_update: (req, res) =>
    Party.findOne
      slug: req.params.party
    .populate '_owner attendees._user', 'username'
    .exec (err, result) ->
      res.render 'parties/edit',
        party: result

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
      party.attendees.push {_user: res.locals.user._id}
      _.each _.pluck(users, '_id'), (id)->
        party.attendees.push {_user: id}
      party.save (err, result) ->
        res.redirect "/parties/#{result.slug}"

  update: (req, res) =>
    Party.findOne
      slug: req.params.party
    .exec (err, party) =>
      party.name = req.body.name
      party.slug = @slugify_unique(req.body.name)
      party.description = req.body.description
      party.date = req.body.date
      party.time = req.body.time

      attendees = req.body.attendees
      attendees = if _.isArray attendees then attendees else [attendees]
      User.find
        username:
          $in:
            attendees
      .exec (err, users) ->
        newUsers = _.map _.pluck(users, '_id'), (id) -> "#{id}"
        oldUsers = _.map _.pluck(party.attendees, '_user'), (id) -> "#{id}"
        toAdd = _.difference newUsers, oldUsers
        toRemove = _.difference oldUsers, newUsers

        if _.isEmpty(toAdd) and _.isEmpty(toRemove)
          party.save (err, result) ->
            res.redirect "/parties/#{result.slug}"
        else
          if !_.isEmpty(toAdd)
            _.each toAdd, (id)->
              party.attendees.push {_user: id}
          if !_.isEmpty(toRemove)
            _.each toRemove, (id) ->
              party.attendees =  _.reject party.attendees, (att) ->
                "#{att._user}" is "#{id}"
          party.save (err, result) ->
            res.redirect "/parties/#{result.slug}"

  delete: (req, res) =>
    res.send "DELEEEEEEEEEEEEETE!"

  add_recipe: (req, res) =>
    Party.findOne
      slug: req.params.party
    .populate '_owner attendees._user', 'username'
    .exec (err, party) ->
      recipe = _.filter party.attendees, (user) ->
        return "#{user._user._id}" is "#{res.locals.user._id}"
      recipe[0].recipes.push
        name: req.body.recipe.name
        slug: req.body.recipe.slug

      party.save (err, result) ->
        if result then res.send true else res.send false

  remove_recipe: (req, res) =>
    Party.findOne
      slug: req.params.party
    .populate '_owner attendees._user', 'username'
    .exec (err, party) ->
      recipe = _.filter party.attendees, (user) ->
        return "#{user._user._id}" is "#{res.locals.user._id}"
      recipe[0].recipes.pop
        slug: req.body.recipe
      party.save (err, result) ->
        if result then res.send true else res.send false


module.exports = PartyCtrl
