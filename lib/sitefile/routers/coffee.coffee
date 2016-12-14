###
###
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'

cc = require 'coffee-script'


# Given sitefile-context, export metadata for coffee: handler
module.exports = ( ctx={} ) ->

  #_.defaults ctx,

  name: 'coffee'
  label: 'Coffee-Script publisher'
  usage: """
    coffee:**/*.coffee
  """

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->

      ( req, res ) ->
        sitefile.log 'Coffe-Script compile', rctx.res.path
        res.type 'js'
        res.write cc._compileFile rctx.res.path
        res.end()



