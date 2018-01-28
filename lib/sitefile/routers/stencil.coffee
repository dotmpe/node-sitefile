Router = require '../Router'


module.exports = ( ctx ) ->

  express = require 'express'
  stencil = require '@stencil/core/server'

  name: 'stencil'
  label: 'Stencil Web-Component publisher'
  usage: """
    stencil: stencil.config.js
  """

  defaults:
    handler: 'publish'

  generate:

    publish: ( rctx ) ->
      config = stencil.loadConfig Router.expand_path rctx.route.spec, ctx
      rctx.root().app.use stencil.ssrPathRegex, stencil.ssrMiddleware({ config })
      rctx.root().app.use express.static config.wwwDir
      null
