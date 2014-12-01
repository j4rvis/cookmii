var mongoose = require ('mongoose');
var Recipe = require("./app/models/Recipe");
var User = require("./app/models/User");

mongoose.connect('mongodb://localhost:27017/cookme');

if(mongoose.connection.readyState === 2)
  console.log("Connection established!");

var user = process.argv[2];
var numberOfRecipes = process.argv[3];

User.findOne({'local.username': user}, function(err, user){
  if(err)
    throw err;
  if(user===null)
    console.log('No user found with this username');
  else{
    console.log(user);
  }
  process.exit(1);
});

// if user not found -> exit
