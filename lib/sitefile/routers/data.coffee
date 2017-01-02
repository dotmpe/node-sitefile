
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
    json: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "JSON", rctx.res.path
        data = fs.readFileSync rctx.res.path
        res.type 'json'
        res.write data
        res.end()


