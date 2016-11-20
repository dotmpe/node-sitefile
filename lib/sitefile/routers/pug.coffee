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


  compilePug = ( path, options ) ->

    # Compile template from file
    tpl = pug.compileFile path, options.compile

    # Merge with options and context
    tpl options.merge

  name: 'pug'
  label: 'Pug templates'
  usage: """
    pug:**/*.pug
  """

  compile: compilePug

  defaults:
    route:
      options:
        scripts: []
        stylesheets: []
        pug:
          format: 'html'
          compile:
            pretty: false
            debug: false
            compileDebug: false
            globals: []

  # generators for Sitefile route handlers
  generate: ( rctx ) ->

    ( req, res ) ->

      console.log 'Pug compile', path: rctx.res.path, \
          "with", options: rctx.route.options

      pugOpts = {
        compile: rctx.route.options.pug.compile
        merge:
          options: rctx.route.options
          query: req.query
          context: rctx
      }

      if not pugOpts.compile.filters
        pugOpts.compile.filters = {}

      res.type rctx.route.options.pug.format
      res.write compilePug rctx.res.path, pugOpts
      res.end()


