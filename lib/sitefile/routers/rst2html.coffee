_ = require 'lodash'
fs = require 'fs'
path = require 'path'
child_process = require 'child_process'

sitefile = require '../sitefile'
du_router_mod = require './du'


# Given sitefile-context, export rst2html: router module
module.exports = ( ctx={} ) ->

  du_router = du_router_mod ctx
  if not du_router or not du_router.prereqs.test_for_fe 'rst2html'
    sitefile.warn "No Docutils: rst2html"
    return

  _.defaults ctx,

    # base-url / prefix for local routes
    base_url: null

  # Return obj. w/ metadata & functions
  name: 'rst2html'
  label: 'Docutils rSt to HTML publisher'

  generate: ( rsctx ) ->

    docpath = path.join ctx.cwd, rsctx.path

    ( req, res, next ) ->

      req.query = _.defaults req.query || {},
        format: 'html'
        docpath: docpath

      params = if ctx.sitefile.params and 'rst2html' of ctx.sitefile.params \
        then ctx.resolve 'sitefile.params.rst2html' else {}

      try
        du_router.tools.rst2html res, _.merge {}, params, req.query
      catch error
        console.trace error
        console.log error.stack
        res.type 'text/plain'
        res.status 500
        res.write "exec error: #{error}"
        res.end()

  route:
    base: ctx.base_url
    rst2html:
      get: (req, res, next) ->

        req.query = _.defaults res.query || {}, format: 'xml'

        try
          rst2html res, _.merge {}, ctx.sitefile.specs.rst2html, req.query
          du_router.tools.rst2html res, _.merge {}, params, req.query
        catch error
          console.trace error
          lib.warn error.stack
          res.type 'text/plain'
          res.status 500
          res.write "exec error: #{error}"
        res.end()

