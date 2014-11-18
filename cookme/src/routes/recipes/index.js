(function() {
  module.exports = function(app) {
    var Recipe;
    Recipe = {
      model: require('../../models/recipes'),
      slugify: function(text) {
        var date, tr;
        tr = {
          "ä": "ae",
          "ü": "ue",
          "ö": "oe",
          "ß": "ss"
        };
        text = text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[äöüß]/g, function($0) {
          return tr[$0];
        }).replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace(/-+$/, '');
        date = new Date();
        return text + '_' + date.getTime();
      }
    };
    require('./list')(app, Recipe);
    require('./create')(app, Recipe);
    require('./show')(app, Recipe);
    return require('./delete')(app, Recipe);
  };

}).call(this);
