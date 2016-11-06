path = require 'path'

sitefile = require '../sitefile'


module.exports = ( ctx={} ) ->

  name: 'sitefile'
  label: ''
  usage: """
    sitefile:**/*.json
  """

  generate: ( rsctx ) ->

    #json = require path.join ctx.cwd, rsctx.path

    ( req, res ) ->

      res.write JSON.stringify ctx._data
      res.end()


