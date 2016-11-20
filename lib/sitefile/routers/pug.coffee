###
###
_ = require 'lodash'
path = require 'path'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for pug: handlers
module.exports = ( ctx ) ->

  try
    pug = require 'pug'
  catch
    return

  #_.defaults ctx,

  name: 'pug'
  label: 'Pug templates'
  usage: """
    pug:**/*.pug
  """

  defaults:
    route:
      options:
        scripts: []
        stylesheets: []
        pug:
          pretty: false
          debug: false
          compileDebug: false
          globals: []

  # generators for Sitefile route handlers
  generate: ( rctx ) ->

    ( req, res ) ->

      console.log 'Pug compile', path: rctx.res.path, \
          "with", options: rctx.route.options

      # Compile template from file
      tpl = pug.compileFile rctx.res.path, req.query.pug

      # Merge with options and context
      res.write tpl {
        options: rctx.route.options
        query: req.query
        context: rctx
      }

      res.end()


