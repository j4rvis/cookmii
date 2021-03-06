Auth = require '../policies/auth'
RecipeCtrl = require('../controllers/RecipeCtrl')
UserCtrl = require('../controllers/UserCtrl')
FavoriteCtrl = require('../controllers/FavoriteCtrl')
HomeCtrl = require('../controllers/HomeCtrl')
PartyCtrl = require('../controllers/PartyCtrl')

RecipeCtrl = new RecipeCtrl
UserCtrl = new UserCtrl
FavoriteCtrl = new FavoriteCtrl
HomeCtrl = new HomeCtrl
PartyCtrl = new PartyCtrl

module.exports = (app) =>

  #
  #   RECIPE
  #
  app.route('/recipes')                     .get                      RecipeCtrl.render_all
  app.route('/recipes/own')                 .get                      RecipeCtrl.render_own
  app.route('/recipes/new')                 .get                      RecipeCtrl.render_create
  app.route('/recipes/:slug')               .get Auth.isPublic,       RecipeCtrl.render
  app.route('/recipes/:slug/edit')          .get Auth.isAuthor,       RecipeCtrl.render_update
  app.route('/recipes/new')                 .post                     RecipeCtrl.create
  app.route('/recipes/:slug/edit')          .post Auth.isAuthor,      RecipeCtrl.update
  app.route('/recipes/:slug')               .delete Auth.isAuthor,    RecipeCtrl.delete

  #
  #   USER
  #
  app.route('/users/:user')                 .get Auth.isLoggedIn,     UserCtrl.render
  app.route('/users')                       .get Auth.isLoggedIn,     UserCtrl.render_all
  app.route('/register')                    .get                      UserCtrl.render_register
  app.route('/login')                       .get                      UserCtrl.render_login
  app.route('/logout')                      .get Auth.isLoggedIn,     UserCtrl.logout
  app.route('/login')                       .post UserCtrl.login,     UserCtrl.redirect_profile
  app.route('/register')                    .post UserCtrl.register,  UserCtrl.redirect_profile

  #
  #   Favorite
  #
  app.route('/favorites')                   .get Auth.isLoggedIn,     FavoriteCtrl.render
  app.route('/recipes/:slug/favcount')      .get Auth.isPublic,       FavoriteCtrl.get_fav_count
  app.route('/recipes/:slug/:user')         .get Auth.isLoggedIn,     FavoriteCtrl.is_favorite
  app.route('/recipes/:slug/:user')         .post Auth.isLoggedIn,    FavoriteCtrl.favorise

  #
  #   Home
  #
  app.route('/')                            .get                      HomeCtrl.render
  app.route('/search')                      .post                     HomeCtrl.search
  app.route('/search/users')                .post Auth.isLoggedIn,    UserCtrl.search
  app.route('/search/recipes')              .post Auth.isLoggedIn,    RecipeCtrl.search

  #
  #   Party
  #
  app.route('/parties')                     .get Auth.isLoggedIn,     PartyCtrl.render_all
  app.route('/parties/new')                 .get Auth.isLoggedIn,     PartyCtrl.render_create
  app.route('/parties/new')                 .post Auth.isLoggedIn,    PartyCtrl.create
  app.route('/parties/:party')              .get Auth.isLoggedIn,     PartyCtrl.render
  app.route('/parties/:party/edit')         .get Auth.isOwner,        PartyCtrl.render_update
  app.route('/parties/:party/edit')         .post Auth.isOwner,       PartyCtrl.update
  app.route('/parties/:party')              .delete Auth.isOwner,     PartyCtrl.delete
  app.route('/parties/:party/addrecipe')    .post Auth.isLoggedIn,    PartyCtrl.add_recipe
  app.route('/parties/:party/rmrecipe')     .post Auth.isLoggedIn,    PartyCtrl.remove_recipe
