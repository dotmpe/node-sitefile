path = require 'path'

_ = require 'lodash'
bookshelf_api = require 'bookshelf-api'

sitefile = require '../sitefile'
knex_util = require '../knex'


# TODO: move to context. Also see knex usage below.
api_cache = {}

load_or_get_api = ( rsctx ) ->
  prefix = path.dirname rsctx.path
  if prefix not of api_cache
    if not global.knex
      global.knex_config = knex_util.load_config rsctx, rsctx.context
      global.knex = require('knex') knex_config
    else
      sitefile.log "Warning, FIXME re-using global knex instances.."
    api_cache[prefix] = bookshelf_api \
                          path: global.knex_config.models.directory
                          #hardDelete: false
                          # FIXME: deletedAttribute translate/test timestamps?
    sitefile.log 'Bookshelf API loaded at', rsctx.name

  api_cache[prefix]


get_api = ( ctx ) ->
  prefix = ctx.ref
  if prefix not of api_cache
    path_els = prefix.split '/'
    path_els.shift()
    api_path_els = []
    while path_els.length
      api_path_els.push path_els.shift()
      prefix = api_path_els.join('/')
      if prefix of api_cache then break
  if prefix not of api_cache
    throw Error "No API found at any prefix of #{ctx.name}"
  sitefile.log 'Bookshelf API re-used at', ctx.name
  api_cache[prefix]


module.exports = ( ctx ) ->

  name: 'bookshelf-api'
  label: ''
  usage: """
    bookshelf-api:**/*.sqlite
  """

  generate: ( rs ) ->

    if 'path' of rs
      api = load_or_get_api rs

      sitefile.log 'Bookshelf API from', rs.path
      ctx.app.use ctx.base+rs.name, api

      ctx.app.get ctx.base+rs.name+'/debug', (req, res) ->
        d = {}
        _ctx = rs
        while _ctx
          d = _.merge d, _ctx._data
          _ctx = _ctx.context
        res.write JSON.stringify d
        res.end()

    else if 'spec' of rs
      api = get_api rs

      if rs.spec.startsWith 'route-model.'
        model = api rs.spec.substr 12
        ctx.app.get rs.ref, model

      else
        throw Error "Unexpected bookshelf-api spec: #{rs.spec} (#{rs.ref})"

    else
      throw Error "Unexpected bookshelf-api resource context (#{rs.ref})"

    null


if 'bookshelf-api' is path.basename process.argv[1], '.coffee'
  console.log 'mod'

