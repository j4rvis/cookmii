module.exports = function (app){

  var Recipe = app.locals.Recipe;

  app.route('/recipes/:slug')
    .delete(Recipe.isLoggedIn, Recipe.isAuthor, function (req, res) {
      Recipe.model.remove({
        slug: req.params.slug
      }, function(err, recipe) {
        if (err)
          res.send(err);
        res.send((recipe === 1) ? { msg: '' } : { msg:'error: ' + err });
      });
    });
}