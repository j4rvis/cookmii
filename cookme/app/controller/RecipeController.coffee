model = require '../models/recipes'

exports.findAll = (callback) ->
  model.find 'public':true, (err, recipes) ->
    callback err,recipes

