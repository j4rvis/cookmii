module.exports = function(app, passport){
  require('./users')(app, passport);
  require('./recipes')(app);

  app.route('/').get(function (req, res){
    res.redirect('/recipes');
  });
}