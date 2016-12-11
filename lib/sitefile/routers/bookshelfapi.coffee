path = require 'path'

_ = require 'lodash'

sitefile = require '../sitefile'

knex_util = require '../knex'


module.exports = ( ctx ) ->

  try
    bookshelf_api = require 'bookshelf-api'
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err

  # TODO: move to context. Also see knex usage below.

  api_cache = {}

  load_or_get_api = ( rctx ) ->
    prefix = path.dirname rctx.res.path
    if prefix not of api_cache
      if not global.knex
        global.knex_config = knex_util.load_config rctx, rctx.context
        global.knex = require('knex') knex_config
      else
        sitefile.log "Warning, FIXME re-using global knex instances.."
      api_cache[prefix] = bookshelf_api \
                            path: global.knex_config.models.directory
                            #hardDelete: false
                            # FIXME: deletedAttribute translate/test timestamps?
      sitefile.log 'Bookshelf API loaded at', rctx.name

    api_cache[prefix]


  get_api = ( rctx ) ->
    prefix = rctx.res.ref
    if prefix not of api_cache
      path_els = prefix.split '/'
      path_els.shift()
      api_path_els = []
      while path_els.length
        api_path_els.push path_els.shift()
        prefix = api_path_els.join('/')
        if prefix of api_cache then break
    if prefix not of api_cache
      throw Error "No API found at any prefix of #{rctx.name}"
    sitefile.log 'Bookshelf API re-used at', rctx.name
    api_cache[prefix]



  name: 'bookshelfapi'
  label: ''
  usage: """
    bookshelfapi:**/*.sqlite
  """

  generate:
    default: ( rctx ) ->

      if 'path' of rctx.res
        api = load_or_get_api rctx

        sitefile.log 'Bookshelf API from', rctx.res.path
        ctx.app.use ctx.site.base+rctx.name, api

        ctx.app.get ctx.site.base+rctx.name+'/debug', (req, res) ->
          d = {}
          _ctx = rctx
          while _ctx
            d = _.merge d, _ctx._data
            _ctx = _ctx.context
          res.write JSON.stringify d
          res.end()

      else if 'spec' of rctx.res
        api = get_api rctx

        if rctx.res.spec.startsWith 'route-model.'
          model = api rctx.route.spec.substr 12
          ctx.app.get rctx.res.ref, model

        else
          throw Error \
            "Unexpected bookshelf-api spec: #{rctx.res.spec} (#{rctx.res.ref})"

      else
        throw Error \
          "Unexpected bookshelf-api resource context (#{rctx.res.ref})"

      null


