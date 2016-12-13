#fs = require 'fs' #path = require 'path'
#sitefile = require '../sitefile'
#_ = require 'lodash'


module.exports = ( ctx ) ->

  name: 'app-0'
  label: 'HTML5 Sitefile Client prototype'
  usage: """
    app-0:**/*.app-0
  """

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        res.type 'txt'
        res.end()

    reader: ( rctx ) ->
      ( req, res ) ->
        res.type 'txt'
        res.end()

