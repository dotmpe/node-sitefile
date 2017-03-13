###
###
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'
Router = require '../Router'

cc = require 'coffee-script'


# Given sitefile-context, export metadata for coffee: handler
module.exports = ( ctx={} ) ->

  name: 'coffee'
  label: 'Coffee-Script publisher'
  usage: """
    coffee:**/*.coffee
  """

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->

      ( req, res ) ->
        cpath = if rctx.res.path then rctx.res.path else rctx.route.spec
        cpath = Router.expand_path cpath, ctx
        sitefile.log 'Coffe-Script compile', cpath
        res.type 'js'
        res.write cc._compileFile cpath
        res.end()


