module.exports = function(app, passport) {

  app.route('/logout')
    .get(function (req, res) {
      req.logout();
      res.redirect('/');
    });
}