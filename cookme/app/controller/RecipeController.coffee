model = require '../models/recipes'

exports.findAll = (callback) ->
  model.find 'public':true, (err, recipes) ->
    callback err,recipes

exports.findOne = (slug, callback) ->
  model.findOne 'slug': slug, (err, recipes) ->
    callback err,recipes