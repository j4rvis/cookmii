class BaseCtrl
  slugify: (text) ->
    tr =
      "ä":"ae"
      "ü":"ue"
      "ö":"oe"
      "ß":"ss"
    text = text.toString().toLowerCase()
      .replace /\s+/g, '-'
      .replace /[äöüß]/g, ($0) -> tr[$0]
      .replace /[^\w\-]+/g, ''
      .replace /\-\-+/g, '-'
      .replace /^-+/, ''
      .replace /-+$/, ''

  slugify_unique: (text) ->
    "#{@slugify(text)}#{new Date().getTime()}"

module.exports = BaseCtrl
