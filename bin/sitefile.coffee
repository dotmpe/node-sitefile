#!/usr/bin/env coffee

lib = require '../lib/sitefile'
_ = require 'lodash'



# export server-start callback
sitefile_cli = module.exports =

  # read-only public vars
  port: null
  host: null
  path: null
  netpath: null
  root: null
  proc: null

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

  run: ( done, options={} ) ->

    # prepare context and config data, loads sitefile
    ctx = lib.prepare_context options
    if _.isEmpty ctx.sitefile.routes
      lib.warn 'No routes'
      process.exit()

    # initialize Express
    express_handler = require '../lib/sitefile/express'
    ctx.app = express_handler ctx
  
    # further Express setup using sitefile
    sf = new lib.Sitefile ctx

    ctx.site.netpath = "//"+ctx.site.host+':'+ctx.site.port+ctx.site.base

    # serve forever
    console.log "Starting server at localhost:#{ctx.site.port}"
    if ctx.site.host
      proc = ctx.server.listen ctx.site.port, ctx.site.host, ->
        lib.log "Listening", "Express server on port #{ctx.site.port}. "
    else
      proc = ctx.server.listen ctx.site.port, ->
        lib.log "Listening", "Express server on port #{ctx.site.port}. "

    # "Export"
    sitefile_cli.host = module.host = ctx.site.host
    sitefile_cli.port = module.port = ctx.site.port
    sitefile_cli.path = module.path = ctx.site.base
    sitefile_cli.netpath = module.netpath = ctx.site.netpath

    sitefile_cli.root = module.root = ctx
    sitefile_cli.proc = module.exports = proc

    !done || done()
    proc


if process.argv[2] in [ '--version', '--help' ]
 
  console.log "sitefile/"+lib.version


else if process.argv[1].endsWith('sitefile') \
    or process.argv[1].endsWith 'sitefile.coffee'

  if process.env.SITEFILE_PM2_MON
    try
      pmx = require 'pmx'
      sitefile_cli.monitor()
    catch error
      if error.code != 'MODULE_NOT_FOUND'
        process.exit 1
    
  sitefile_cli.run()

#else
#  lib.warn "Invalid argument:", process.argv[2]
#  process.exit(1)


# Id: node-sitefile/0.0.5-dev bin/sitefile.coffee
# vim:ft=coffee:
