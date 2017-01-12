_ = require 'lodash'
path = require 'path'
fs = require 'fs'
URL = require 'url'

Router = require '../Router'

Promise = require 'bluebird'


version = '0.0.1'


module.exports = ( ctx, auto_export=false, base=ctx.base ) ->

  httprouter = require('./http') ctx

  mount = ctx.get_auto_export( 'rjs' ) or 'app/rjs'

  # Additional defaults
  autoExport = if not autoExport then {} else \
    local:
      "#{mount}":
        tpl: 'sitefile-client:rjs.pug'
        merge:
          stylesheets: [
            '/vendor/bootstrap.css'
            '/vendor/bootstrap-theme.css'
            '/media/style/default.css'
            '/example/server-generated-stylesheet' ]
          scripts: [
            '/vendor/jquery.js' ]
          clients: [
            type: 'require-js'
            id: 'require-js-sitefile-v0-app'
            href: '/vendor/require.js'
            main: '/app/rjs-sf-v0.js'
          ]


  name: 'rjs'

  label: "Require.JS client app"
  description: """
    `rjs` generates parts for a view with one or more Require.JS applictions.
  """
  usage: """
  """

  defaults: _.defaultsDeep autoExport, \
    handler: 'main'
    routes: """
      #{mount}/main.js: rjs.main:#
      #{mount}/json: rjs.data:paths=;map=;main=;baseUrl=
      #{mount}: pug:tpl=sitefile-client:rjs.pug
    """
    global: {}
    ### FIXME: would want to set defaults for pug view. but setup auto-export
      first
      default:
        options:
          merge:
      Also all settings in sitefile for now, later rebuild rctx init like in pug
      config:
        options: {}
      main:
        options: {}
    ###

  generate:

    # Return registry for require-js app
    config: ( rctx ) ->
      res:
        data: ( dctx ) ->
          { baseUrl, paths, map, shims, main, deps } = \
            Router.parse_kw_spec rctx

          if paths and paths.startsWith '$ref:'
            paths = Router.read_xref ctx, paths.substr 5
          else if 'string' is typeof paths
            paths = {}

          if 'object' is typeof map or not map
            map = {}
    
          map["*"] = {
            "sitefile": "sf-v0"
          }

          if 'string' is typeof shims
            shims = {}

          if not shims
            shims = {}

          baseUrl: baseUrl or rctx.res.ref
          paths: paths
          map: map
          shims: shims
          deps: [ main ]

    main: ( rctx ) ->
      ( req, res ) ->

        write = ( url, srcPath, data ) ->
          res.type "application/javascript"
          res.write "/* Config from #{url} ( #{srcPath} ) */ "
          res.write "requirejs.config(#{data});"
          res.end()

        url = ctx.base()+rctx.route.spec

        if fs.existsSync rctx.route.spec
          p = path.join ctx.cwd, rctx.route.spec
          rjs_opts = JSON.stringify require p
          write url, p, rjs_opts

        else if url of ctx.routes.resources
          rrctx = ctx.routes.resources[url]
          rjs_opts = JSON.stringify rrctx.res.data rctx
          write url, rrctx.route.spec, rjs_opts

        else
          httprouter.promise.resource(url).then ( data ) ->
            rjs_opts = JSON.stringify data
            write url, url, rjs_opts

