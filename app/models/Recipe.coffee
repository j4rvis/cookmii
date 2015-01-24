mongoose = require('mongoose')
Schema = mongoose.Schema

IngredientSchema = new Schema
  name: String
  slug: String
  quantity: Number
  unit:
    type: String
    default: ''

CategorySchema = new Schema
  name: String
  slug: String

FavoriteSchema = new Schema
  user: String

RecipeSchema = new Schema
  name: String
  slug: String
  manual:
    type: String
    default: ''
  image: String
  author: String
  isPublic:
    type: Boolean
    default: false
  favorites: [FavoriteSchema]
  ingredients: [IngredientSchema]
  categories: [CategorySchema]
  updated:
    type: Date
    default: Date.now

RecipeSchema.set('toObject', {virtuals: true })

RecipeSchema.methods.isFavorite = (user, callback) ->
  @model('Recipe').find
    slug: @slug
    'favorites.user': user
  ,(err, result) ->
    if result.length > 0
      callback(true)
    else
      callback(false)

RecipeSchema.methods.bestFromAuthor = (callback) ->
  @model('Recipe').find
    author: @author
    isPublic:true
  .sort({favCount:-1})
  .limit(5)
  .exec (err, result) ->
    callback(result)

RecipeSchema.virtual('favCount').get ->
  @favorites.length

module.exports = mongoose.model('Recipe', RecipeSchema)