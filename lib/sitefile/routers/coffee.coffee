###
###
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'

cc = require 'coffee-script'


# Given sitefile-context, export metadata for coffee: handlers
module.exports = ( ctx={} ) ->

  #_.defaults ctx,

  name: 'coffee'
  label: 'Coffee-Script publisher'
  usage: """
    coffee:**/*.coffee
  """

  # generators for Sitefile route handlers
  generate: ( rctx ) ->

    ( req, res ) ->
      sitefile.log 'Coffe-Script compile', rctx.res.path
      res.write cc._compileFile rctx.res.path
      res.end()



