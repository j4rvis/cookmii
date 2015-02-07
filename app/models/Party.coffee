mongoose = require('mongoose')
Schema = mongoose.Schema

AttendeeSchema = new Schema
  _user:
    type: Schema.Types.ObjectId
    ref: 'User'
  recipes: [
    name: String
    slug: String
  ]

PartySchema = new Schema
  name: String
  slug: String
  description: String
  date: String
  time: String
  _owner:
    type: Schema.Types.ObjectId
    ref: 'User'
  attendees: [AttendeeSchema]

module.exports = mongoose.model('Party', PartySchema)
