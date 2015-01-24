Auth = require '../policies/auth'
RecipeCtrl = require('../controllers/RecipeCtrl')
UserCtrl = require('../controllers/UserCtrl')
FavoriteCtrl = require('../controllers/FavoriteCtrl')
HomeCtrl = require('../controllers/HomeCtrl')

RecipeCtrl = new RecipeCtrl
UserCtrl = new UserCtrl
FavoriteCtrl = new FavoriteCtrl
HomeCtrl = new HomeCtrl

module.exports = (app) =>

  #
  #   RECIPE
  #
  app.route('/recipes')                 .get                      RecipeCtrl.render_all
  app.route('/recipes/own')             .get                      RecipeCtrl.render_own
  app.route('/recipes/new')             .get                      RecipeCtrl.render_create
  app.route('/recipes/:slug')           .get Auth.isPublic,       RecipeCtrl.render
  app.route('/recipes/:slug/edit')      .get Auth.isAuthor,       RecipeCtrl.render_update
  app.route('/recipes/new')             .post                     RecipeCtrl.create
  app.route('/recipes/:slug/edit')      .post Auth.isAuthor,      RecipeCtrl.update
  app.route('/recipes/:slug')           .delete Auth.isAuthor,    RecipeCtrl.delete

  #
  #   USER
  #
  app.route('/users/:user')             .get Auth.isLoggedIn,     UserCtrl.render
  app.route('/users')                   .get Auth.isLoggedIn,     UserCtrl.render_all
  app.route('/register')                .get                      UserCtrl.render_register
  app.route('/login')                   .get                      UserCtrl.render_login
  app.route('/logout')                  .get Auth.isLoggedIn,     UserCtrl.logout
  app.route('/login')                   .post UserCtrl.login,     UserCtrl.redirect_profile
  app.route('/register')                .post UserCtrl.register,  UserCtrl.redirect_profile

  #
  #   Favorite
  #
  app.route('/favorites')               .get Auth.isLoggedIn,     FavoriteCtrl.render
  app.route('/recipes/:slug/favcount')  .get Auth.isPublic,       FavoriteCtrl.get_fav_count
  app.route('/recipes/:slug/:user')     .get Auth.isLoggedIn,     FavoriteCtrl.is_favorite
  app.route('/recipes/:slug/:user')     .post Auth.isLoggedIn,    FavoriteCtrl.favorise

  #
  #   Home
  #
  app.route('/')                        .get                      HomeCtrl.render
  app.route('/search')                  .post                     HomeCtrl.search
