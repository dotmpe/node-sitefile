Router = require '../Router'

# TODO: create a demo/test router with established Sf routing impl.

module.exports = ( ctx ) ->

  express = require 'express'
  console.log 'Demo router module init completed'

  # Return standard Sf router object

  name: 'demo'
  label: ''
  usage: """
    demo: demo:
    demo-s-dir: demo.static:dir
    demo-mw: demo.middleware:userspec

    demo-pug-tpl: demo.pug:userspec
    demo-pug: demo.pug-html:tpl:data
  """

  defaults:
    handler: 'default'

  generate:
    default: ( rctx ) ->

    static: ( rctx ) ->
      # A null-return style Sf router that adds its own Express static routes
      rctx.root().app.use express.static static_dir
      null

    middleware: ( rctx ) ->
      # A null-return style Sf router that adds its own Express middleware
      config = middleware.rc Router.expand_path rctx.route.spec, ctx
      rctx.root().app.use middleware.routespec, middleware( config )
      null

    pug: ( rctx ) ->
      # Router using another router
      sfpug = ctx._routers.get('pug')

    'pug-html': ( rctx ) ->
      # Router using another router
      sfpug = ctx._routers.get('pug')

    file: ( rctx ) ->
      # Router using another router
      sffile = ctx._routers.get('file')
      cache[spec] = new sffile.StaticFile spec
