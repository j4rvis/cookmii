mongoose = require 'mongoose'
Schema = mongoose.Schema

IngredientSchema = new Schema
  name: String
  quantity: Number
  unit: String

CategorySchema = new Schema
  name: String

FavoriteSchema = new Schema
  user: String

RecipeSchema = new Schema
  name: String
  slug: String
  description: String
  image: String
  author: String
  isPublic: Boolean
  favorites: [FavoriteSchema]
  ingredients: [IngredientSchema]
  catagories: [CategorySchema]
  updated: 
    type: Date
    default: Date.now

module.exports = mongoose.model 'Recipe', RecipeSchema