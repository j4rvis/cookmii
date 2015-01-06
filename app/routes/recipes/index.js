module.exports = function(app){

  require('./list')(app);
  require('./create')(app);
  require('./show')(app);
  require('./edit')(app);
  require('./fav')(app);
  require('./delete')(app);
}
