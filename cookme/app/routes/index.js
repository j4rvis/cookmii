module.exports = function(app){
  require('./users')(app);
  require('./recipes')(app);

  app.route('/').get(function (req, res){
    res.redirect('/recipes');
  });
}