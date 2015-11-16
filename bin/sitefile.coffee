#!/usr/bin/env coffee

lib = require '../lib/sitefile'


# prepare server context
init = ->

  # prepare context and config, load sitefile
  ctx = lib.prepare_context ctx

  # initialize Express
  express_handler = require '../lib/sitefile/express'
  ctx.app = express_handler ctx

  # Load needed routers and parameters
  lib.load_routers ctx

  # apply Sitefile routes
  lib.apply_routes ctx.sitefile, ctx

  # reload ctx.{config,sitefile} whenever file changes
  lib.reload_on_change ctx.app, ctx

  ctx


# export server
module.exports =
  port: null
  proc: null
  init: init
  run: ( done ) ->
    ctx = module.exports.init()
    # serve forever
    proc = ctx.server.listen ctx.port, ->
      lib.log "Listening", "Express server on port #{ctx.port}. "
    console.log "Starting server at localhost:#{ctx.port}"
    module.exports.port = ctx.port
    module.exports.proc = proc
    !done || done()
    proc


# start if directly executed
if process.argv.join(' ') == 'coffee '+require.resolve './sitefile.coffee'

  module.exports.run()


# Id: node-sitefile/0.0.4-demo+20151116-0604 bin/sitefile.coffee
# vim:ft=coffee:
