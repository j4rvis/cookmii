(function() {
  var model;

  model = require('../models/recipes');

  exports.findAll = function(callback) {
    return model.find({
      'public': true
    }, function(err, recipes) {
      return callback(err, recipes);
    });
  };

}).call(this);
