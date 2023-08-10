#!/usr/bin/env coffee

path = require 'path'

_ = require 'lodash'
neodoc = require 'neodoc'
express = require 'express'
pmx = null

lib = require '../lib/sitefile'
sf_express = require '../lib/sitefile/express'

require '../lib/strutil'



sitefile_cli = module.exports =

  # read-only public vars
  port: null
  host: null
  path: null
  netpath: null
  root: null
  proc: null

  startExpress: ( ctx ) ->

    app = express()
    ctx.server = require("http").createServer(app)

    sf_express.init( app, ctx )

    app.set 'query parser', sf_express.query_parser
    ctx.static_proto = express.static
    ctx.redir = ( ref, p ) ->
      # Express redir handler
      ctx.app.all ref, (req, res) ->
        res.redirect p

    app

  run_main: ( done, options={}, ctxp={} ) ->
    vOpt = String(options['--bwc'])
    switch

      when vOpt.startsWith '0.0'
        # prepare context instance with config data, loads sitefile and packages
        ctx = lib.prepare_context ctxp

        if options['--verbose']
          ctx.verbose = true

        if _.isEmpty ctx.sitefile.routes
          lib.warn 'No routes, exiting'
          process.exit()

        if options['--host']
          ctx.site.host = options['--host']
        else if process.env.SITEFILE_HOST
          ctx.site.host = process.env.SITEFILE_HOST

        if options['--port']
          ctx.site.port = options['--port']
        else if process.env.SITEFILE_PORT
          ctx.site.port = process.env.SITEFILE_PORT

        # create Express instance with HTTP server
        ctx.app = sitefile_cli.startExpress ctx

        # Bootstrap app setup using sitefile mapping and loaded router modules
        sf = new lib.Sitefile ctx

        # set full path for export
        ctx.site.netpath = "//"+ctx.site.host+':'+ctx.site.port+ctx.site.base

      when vOpt.startsWith '0.1'
        console.log 'XXX: if needed, per-version/backward-compat init', vOpt
        process.exit 1

      else
        console.log 'Unknown backward-compat', vOpt
        process.exit 3
        

    # serve forever
    proc = sitefile_cli.serve done, ctx
    # export main components to module

    sitefile_cli.export ctx,
      root: ctx
      proc: proc
    [ sf, ctx, proc ]

  serve: ( done, ctx ) ->
    console.log "Starting #{ctx.version} "+\
      "(Express #{ctx.express_version}) "+\
      "server at #{ctx.site.host}:#{ctx.site.port}"

    return if ctx.site.host
      ctx.server.listen ctx.site.port, ctx.site.host, ->
        if ctx.verbose
          lib.log "Listening", "Express server on port #{ctx.site.port}. "
        !done || done()
    else
      ctx.server.listen ctx.site.port, ->
        if ctx.verbose
          lib.log "Listening", "Express server on port #{ctx.site.port}. "
        !done || done()

  export: ( ctx, map ) ->
    for attr in [ "host", "port", "path", "netpath" ]
      sitefile_cli[attr] = module.exports[attr] = ctx.site[attr]
    for atr, o of map
      sitefile_cli[atr] = module.exports[atr] = o

  monitor: ->
    probe = pmx.probe()
    metrics = {
      hostname: probe.metric
        name: 'Hostname'
        value: -> sitefile_cli.host
      portnumber: probe.metric
        name: 'Port'
        value: -> sitefile_cli.port
      pathprefix: probe.metric
        name: 'Path'
        value: -> sitefile_cli.path
      hyperlink: probe.metric
        name: 'Netpath'
        value: -> 'http:'+sitefile_cli.netpath
      routes: probe.metric
        name: 'Routes'
        value: ->
          if sitefile_cli.root
            Object.keys(sitefile_cli.root.sitefile.routes).length
      resources: probe.metric
        name: 'Resources'
        value: ->
          if sitefile_cli.root
            sitefile_cli.root.routes.resources.length
      directories: probe.metric
        name: 'Directories'
        value: ->
          if sitefile_cli.root
            Object.keys(sitefile_cli.root.routes.directories).length
    }



if process.argv[1].endsWith('sitefile') \
    or process.argv[1].endsWith 'sitefile-cli.coffee'
  opts = neodoc.run """

  Usage: sitefile [--version] [--help] [options]

  options:
    --bwc <bwc-version>      Run at backward-compatible version, iso. version
                             in Sitefile [env: SITEFILE_VERSION]
                             [default: '#{lib.version}']
    --monitor <pmx-on>       Enable PM2 monitor extension, this initalizes
                             a probe with internal metrics of the sitefile
                             process. [env: SITEFILE_PM2_MON]
    --quiet                  Be quiet, disable console log
    --verbose                Set verbose console log
    --host NAME              .
    --port NUM               .

  """, { optionsFirst: false, laxPlacement: true, smartOptions: true }
  if opts['--monitor']
    try
      pmx = require 'pmx'
      sitefile_cli.monitor()
    catch error
      if error.code != 'MODULE_NOT_FOUND'
        process.exit 1
  if opts['--quiet']
    lib.log_enabled = false
  sitefile_cli.run_main null, opts, sfdir: path.dirname __dirname


else if process.env.NODE_ENV == 'testing'
  lib.log_error_enabled = false
  lib.log_enabled = false


else if process.env.NODE_ENV == 'development'
  lib.log_error_enabled = true
  lib.log_enabled = false


else
  lib.warn "Invalid argument:", process.argv[2]
  process.exit(1)



# vim:ft=coffee:
# Id: node-sitefile/0.0.7-dev bin/sitefile-cli.coffee
