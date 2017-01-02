
fs = require 'fs'
sitefile = require '../sitefile'


module.exports = ( ctx ) ->

  name: 'data'
  label: 'JSON/YAML/...'
  usage: """
    json:**/*.json
  """

  defaults:
    default: 'json'

  generate:
    'json/load': ( rctx ) ->
      res:
        data: ( dctx ) ->
          fs.readFileSync rctx.res.path

    'json': ( rctx ) ->
      ( req, res ) ->
        url = rctx.res.path
        sitefile.log "JSON", url
        if url in ctx.routes.resources
          if 'object' is typeof ctx.routes.resources[url]
            rrctx = ctx.routes.resources[url]
            data = rrctx.res.data rctx
        else
          data = fs.readFileSync url
        res.type 'json'
        res.write data
        res.end()


