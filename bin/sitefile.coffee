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

  run: ( done ) ->

    # prepare context and config data, loads sitefile
    ctx = lib.prepare_context ctx
    if _.isEmpty ctx.sitefile.routes
      lib.warn 'No routes'
      process.exit()

    # initialize Express
    express_handler = require '../lib/sitefile/express'
    ctx.app = express_handler ctx
  
    # further Express setup using sitefile
    sf = new lib.Sitefile ctx

    host = ctx.host or ''
    site = (
      host: host
      netpath: "//"+host+':'+ctx.port+ctx.base
    )
    ctx.prepare_properties site
    ctx.seed site

    # serve forever
    console.log "Starting server at localhost:#{ctx.port}"
    if ctx.host
      proc = ctx.server.listen ctx.port, ctx.host, ->
        lib.log "Listening", "Express server on port #{ctx.port}. "
    else
      proc = ctx.server.listen ctx.port, ->
        lib.log "Listening", "Express server on port #{ctx.port}. "

    # "Export"
    sitefile_cli.host = ctx.host
    sitefile_cli.port = ctx.port
    sitefile_cli.path = ctx.base
    sitefile_cli.netpath = ctx.netpath

    sitefile_cli.root = ctx
    sitefile_cli.proc = proc

    !done || done()
    proc


# start if directly executed
if process.argv.join(' ') == 'coffee '+require.resolve './sitefile.coffee'

  try
    pmx = require 'pmx'
    sitefile_cli.monitor()
  catch error
    
  sitefile_cli.run()

else if process.argv[2] in [ '--version', '--help' ]
 
  console.log "sitefile/"+lib.version

# TODO: detect execute or (test-mode) include
#else
#  lib.warn "Invalid argument:", process.argv[2]
#  process.exit(1)


# Id: node-sitefile/0.0.5-dev bin/sitefile.coffee
# vim:ft=coffee:
