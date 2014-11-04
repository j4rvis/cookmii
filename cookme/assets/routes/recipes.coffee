express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.render 'recipes/index',
    title: 'CookMii - Recipes'

module.exports = router;
