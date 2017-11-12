fs = require 'fs'
libsitefile = require '../sitefile'
libconf = require '../../conf'
Router = require '../Router'


module.exports = ( ctx ) ->

  name: 'res'
  label: 'JSON/YAML/...'
  usage: """
    json:**/*.json
    yaml:**/*.yaml
  """

  defaults:
    default: 'json'

  generate:
    # FIXME: data builtin
    'json/load': ( rctx ) ->
      res:
        data: ( dctx ) ->
          fs.readFileSync rctx.res.path

    'json': ( rctx ) ->
      ( req, res ) ->
        url = rctx.res.path
        libsitefile.log "JSON", url
        if url in ctx.routes.resources
          if 'object' is typeof ctx.routes.resources[url]
            rrctx = ctx.routes.resources[url]
            data = rrctx.res.data rctx
        else
          data = fs.readFileSync url
        res.type 'json'
        res.write data
        res.end()

    # Load data from local path, resolving named prefixes
    'load-file': ( rctx ) ->
      res:
        data: ->
          fn = Router.expand_path ( if rctx.res.path \
            then rctx.res.path else rctx.route.spec ), ctx
          libsitefile.log "Load File", fn
          libconf.load_file fn

    # TODO: node-json-transform endpoint
    'xform': ( rctx ) ->
      res:
        data: ->
          if not rctx.res.src
            rctx.res.src = URL.parse \
              rctx.site.base+rctx.route.spec.trim '#'
          # TODO: access other resource context by url
          #deref.promise.local_or_remote rctx
