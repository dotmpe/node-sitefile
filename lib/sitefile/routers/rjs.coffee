path = require 'path'
fs = require 'fs'
URL = require 'url'
_ = require 'lodash'

Router = require '../Router'
deref = require '../deref'


version = '0.0.1'

sf_rjs_app =

  'sitefile-rjs-app': ( req, res, rjs, rjs_config, rctx ) ->
    ctx = rctx.context
    ext = if req.params.ext then req.params.ext else req.params[1]
    ctx.log "serving rjs.boot #{ext} from metadata", name: rjs.name+ext
    switch ext
      when '.html'
        res.type 'html'
        sfpug = ctx._routers.get 'pug'
        res.write sfpug.render
          tpl: Router.expand_path rjs.tpl, ctx
          merge:
            context: rctx
            ref: rctx.res.ref
            clients: [
              type: 'require-js'
              href: "/vendor/require.js"
              main: "/app/v0#{rjs_config.name}.js"
            ]
      when '.js'
        rjs_c = JSON.stringify rjs_config
        res.type "application/javascript"
        res.write "requirejs.config(#{rjs_c});"
      when '.app.json'
        res.type 'json'
        res.write JSON.stringify rjs.config
      when '.json'
        res.type 'json'
        res.write JSON.stringify rjs_config
    res.end()

resolve_rjs_config = ( rjs_config, rctx ) ->
  _rjs_config = {}
  for k, v of rjs_config
    if 'string' is typeof(v) and v.trim()
      if v.startsWith '$ref:'
        v = Router.read_xref rctx.context, v.substr 5
      else if v.substring(0, 1) in [ '[', '{' ]
        v = JSON.parse(v)
    _rjs_config[k] = v
  _rjs_config

format_rjs_main_from_ctx = ( req, res, rctx ) ->
  write = ( url, srcPath, data ) ->
    res.type "application/javascript"
    res.write "/* Config from #{url} ( #{srcPath} ) */ "
    res.write "requirejs.config(#{data});"
    res.end()
  ctx = rctx.context

  url = ctx.site.base+rctx.route.spec

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
      #{mount}/main.js: rjs.main:#{mount}/json
      #{mount}/json: rjs.config:paths=;map=;main=;baseUrl=
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
          rjs_spec = Router.parse_kw_spec rctx
          rjs_config = resolve_rjs_config rjs_spec, rctx
          #{ baseUrl, paths, map, shims, deps } = rjs_config
          rjs_config.baseUrl ?= rctx.res.ref
          rjs_config

    define: ( rctx ) ->
      ( req, res ) ->
        res.write "define('', [], function() {"
        res.write
        res.write "});"

    # Produce handler to render just the requirejs main JS, sourced elsewhere
    main: ( rctx ) ->
      # Render JS to call requirejs config, providing all app options as
      # Sitefile route spec
      ( req, res ) ->
        format_rjs_main_from_ctx( req, res, rctx )

    # Produce handlers for both requirejs app JS and the HTML context
    boot: ( rctx ) ->
      rctx.route.metasrc = Router.expand_path rctx.route.spec, ctx
      ctx.log 'rjs.boot', path: rctx.route.metasrc, 'at', url: rctx.name
      deref.promise.metadata(rctx.route.metasrc, rctx).then ( data ) ->
        ctx.log 'rjs.boot metadata resolved for', url: rctx.name
        rctx.route.metadata = data

      # Generate sub-routes, configure most via file given in Sitefile spec
      ( req, res ) ->
        if not rctx.route.metadata
          throw Error "No metadata loaded at #{rctx.name}"
        name = if req.params.name then req.params.name else req.params[0]

        if name not of rctx.route.metadata
          throw Error "No #{name} application at #{rctx.name}"

        rjs = rctx.route.metadata[name]
        rjs_config = resolve_rjs_config rjs.config, rctx
        if not rjs_config.name
          rjs_config.name = name
        type = rjs.type

        if type not of sf_rjs_app then throw Error \
          "No #{type} application handler for #{name} at #{rctx.name}"

        ctx.log "Defer to sf-rjs-app #{type}: #{name} at #{rctx.name}"
        sf_rjs_app[type] req, res, rjs, rjs_config, rctx
