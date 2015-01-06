var mongoose = require('mongoose');
var Schema = mongoose.Schema;

IngredientSchema = new Schema({
  name: String,
  quantity: Number,
  unit: String
});

CategorySchema = new Schema({
  name: String
});

FavoriteSchema = new Schema({
  user: String
});

RecipeSchema = new Schema({
  name: String,
  slug: String,
  manual: String,
  image: String,
  author: String,
  isPublic: Boolean,
  favorites: [FavoriteSchema],
  ingredients: [IngredientSchema],
  categories: [CategorySchema],
  updated:{
    type: Date,
    default: Date.now
  }
});
RecipeSchema.set('toObject', {virtuals: true });

RecipeSchema.methods.isFavorite = function(user, callback){
  this.model('Recipe').find({slug:this.slug, 'favorites.user': user}, function(err, result){
    if(result.length > 0)
      return callback(true);
    else
      return callback(false);
  });
}

RecipeSchema.methods.bestFromAuthor = function(callback){
  this.model('Recipe').find({
    author:this.author,
    isPublic:true
  }).sort({favCount:-1}).limit(5).exec(function(err, result){
    return callback(result);
  });
}

RecipeSchema.virtual('favCount').get(function(){
  return this.favorites.length;
});

module.exports = mongoose.model('Recipe', RecipeSchema);