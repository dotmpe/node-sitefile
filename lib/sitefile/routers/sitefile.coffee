#path = require 'path'

sitefile = require '../sitefile'


module.exports = ( ctx={} ) ->

  name: 'sitefile'
  label: ''
  usage: """
    sitefile:**/*.json
  """

  generate: ( rsctx ) ->

    ( req, res ) ->

      res.type 'json'

      switch rsctx.spec
        when "resource" then res.write JSON.stringify rsctx._data
        when "handler" then res.write JSON.stringify rsctx.context._data
        when "global" then res.write JSON.stringify rsctx.context.context._data

      res.end()


