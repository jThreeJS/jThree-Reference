fs = require 'fs'

###*
 * configuration of stateInitializer
 * @type {Object}
###
module.exports =
  typedoc:
    path_to_json: './src/server/doc.json'
  overview:
    markdown: './src/server/overview.md'
  router:
    root: '/'
