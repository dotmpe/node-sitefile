_ = require 'lodash'
path = require 'path'
Promise = require 'bluebird'



module.exports = ( ctx ) ->

  name: "mocha"
  usage: """
  """

  auto_export:
    route:
      _mocha: "mocha:**/*.mocha"
      "vendor/mocha.js": "static:node_modules/mocha/mocha.js"
      "vendor/chai.js": "static:node_modules/chai/chai.js"
      "vendor/sinon.js": "static:node_modules/sinon/pkg/sinon.js"
    
  default_handler: 'auto'

  defaults:
    client:
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

  generate:
    auto: ( rctx ) ->
    test: ( rctx ) ->
      ( req, res ) ->
        res.write "TODO: run test server site, see about what artefact to serve"
        #res.write pug.compile './lib/sitefile/routers/mocha.pug', pugOpts
        res.end()
    client: ( rctx ) ->
      pug = ctx._routers.get 'pug'
      ( req, res ) ->
        suffix = '_test'
        dud = path.join ctx.site.base, req.params[0]
        pugOpts = _.defaultsDeep rctx.route.pug, {
          merge:
            ref: rctx.res.ref
            route: rctx.route
            query: req.query
            params: req.params
            options: rctx.route.options
            context: rctx

            test_object: dud
            test_file: dud.replace('.js', suffix+'.js')
        }

        res.write pug.compile './lib/sitefile/routers/mocha.pug', pugOpts
        res.end()


