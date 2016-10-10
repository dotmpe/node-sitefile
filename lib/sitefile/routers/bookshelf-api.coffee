path = require 'path'

_ = require 'lodash'
bookshelf_api = require 'bookshelf-api'

sitefile = require '../sitefile'
knex_util = require '../knex'



module.exports = ( ctx ) ->

  name: 'bookshelf-api'
  label: ''
  usage: """
    bookshelf-api:**/*.sqlite
  """

  generate: ( rs ) ->
    sitefile.log 'Bookshelf API at', rs.name
    config = knex_util.load_config rs, ctx
    global.knex = require('knex') config

    api = bookshelf_api path: config.models.directory
    sitefile.log 'Bookshelf API from', config.models.directory
    ctx.app.use ctx.base+rs.name, api

    ctx.app.get ctx.base+rs.name+'/debug', (req, res)->
      d = {}
      _ctx = rs
      while _ctx
        d = _.merge d, _ctx._data
        _ctx = _ctx.context
      res.write JSON.stringify d
      res.end()

    return



if 'bookshelf-api' is path.basename process.argv[1], '.coffee'
  console.log 'mod'

