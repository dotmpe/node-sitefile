#!/usr/bin/env coffee

_ = require 'lodash'
path = require 'path'


lib = require '../src/dotmpe/sitefile'

ctx = routers: {}

# import the local site file
sitefile = ctx.sitefile = lib.get_local_sitefile ctx

# prepare context and sitefile config
lib.prepare_context ctx
lib.load_config ctx

# initialize Express
express_handler = require '../src/dotmpe/sitefile/express'
app = express_handler ctx

# import handler generators
for name in ctx.config.routers
  router_cb = require '../src/dotmpe/sitefile/routers/' + name
  router_obj = router_cb ctx

  ctx.routers[name] = module: router_cb, object: router_obj
  console.log "Loaded router #{name}: #{router_obj.label}"

  handler_generator = router_obj.generate[ router_obj.default ]
  ctx[ name ] = handler_generator

# apply Sitefile routes
lib.apply_routes sitefile, app, ctx

# reload ctx.{config,sitefile} whenever file changes
lib.reload_on_change app, ctx

# server forever
ctx.server.listen ctx.port, ->
  console.log "Express server listening on port " + ctx.port

# vim:ft=coffee:
