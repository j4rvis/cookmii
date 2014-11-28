module.exports = function(app){

  require('./list')( app);
  require('./create')( app);
  require('./show')( app);
  require('./edit')( app);
  // require('./delete')( app, Recipe);
}
