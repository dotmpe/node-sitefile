#!/usr/bin/env coffee

_ = require 'lodash'
path = require 'path'


lib = require '../src/dotmpe/sitefile'


# prepare context and config, load sitefile
ctx = lib.prepare_context ctx

# initialize Express
express_handler = require '../src/dotmpe/sitefile/express'
app = express_handler ctx

# Load needed routers and parameters
lib.load_routers ctx

# apply Sitefile routes
lib.apply_routes ctx.sitefile, app, ctx

# reload ctx.{config,sitefile} whenever file changes
lib.reload_on_change app, ctx

# server forever
ctx.server.listen ctx.port, ->
  lib.log "Listening", "Express server on port #{ctx.port}. "

# vim:ft=coffee:
