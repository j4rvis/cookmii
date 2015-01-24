mongoose    = require('mongoose')
bcrypt      = require('bcrypt-nodejs')

userSchema = mongoose.Schema
  email: String
  password: String
  username: String
  realname: String
  favorites: String
  profile_image: String
  facebook:
    id: String
    token: String
    email: String
    name: String
  twitter:
    id: String
    token: String
    displayName: String
    username: String
  google:
    id: String
    token: String
    email: String
    name: String

userSchema.methods.generateHash = (password) ->
  bcrypt.hashSync(password, bcrypt.genSaltSync(8), null)

userSchema.methods.validPassword = (password) ->
  bcrypt.compareSync(password, @password)

module.exports = mongoose.model('User', userSchema)