var Recipe = {
  model: require("../models/Recipe"),
  slugify: function(text){
    var tr = {"ä":"ae", "ü":"ue", "ö":"oe", "ß":"ss" };
    var text = text.toString().toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[äöüß]/g, function($0){ return tr[$0]})
      .replace(/[^\w\-]+/g, '')
      .replace(/\-\-+/g, '-')
      .replace(/^-+/, '')
      .replace(/-+$/, '');
    return text + '_' + new Date().getTime();
  },
  isLoggedIn: function(req, res, next) {
    if (req.isAuthenticated())
      return next();
    res.redirect('/');
  },
  isAuthor: function(req, res, next) {
    if(res.locals.user){
      Recipe.model.findOne({'slug': req.params.slug, 'author': res.locals.user.local.username }, function(err, recipe) {
        if(recipe)
          return next();
        else
          res.redirect('/recipes');
      });
    } else
      res.redirect('/recipes');
  },
  isPublic: function(req, res, next) {
    if(res.locals.user)
      Recipe.model.findOne({'slug': req.params.slug,
        $or:[{'isPublic': true},{'author':res.locals.user.local.username}]  }, function(err, recipe) {
          if(recipe)
            return next();
          else
            res.redirect('/recipes');
      });
    else
      Recipe.model.findOne({slug: req.params.slug, 'isPublic': true}, function(err, recipe) {
        if(recipe)
          return next();
        else
          res.redirect('/recipes');
      });
  }
}

module.exports = Recipe;