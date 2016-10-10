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
  generate: ( rsctx ) ->

    ( req, res ) ->
      sitefile.log 'Coffe-Script compile', rsctx.path
      res.write cc._compileFile rsctx.path
      res.end()



