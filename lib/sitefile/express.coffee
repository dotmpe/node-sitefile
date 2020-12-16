###
Some parts to deal with the Express initialization, and maybe other things at
the Express layer or HTTP related.
###
path = require 'path'
qs = require 'qs'


init_express = ( app, ctx={} ) ->

  # Have sitefile context ready
  app.set 'context', ctx

  # Handle some minimal Express settings
  app.set 'env', ctx.envname
  app.set 'port', ctx.site.port
  app.set 'host', ctx.site.host
  app.set 'showStackError', ctx.config['show-stack-trace']
  if 'metadata' of ctx.config
    app.set 'metadata', ctx.config['metadata']

  # Get a generic templater and set our filename extensions
  engines = require 'consolidate'
  for ext_engine_map in ctx.config.engines
    if 'string' is typeof ext_engine_map
      app.engine ext_engine_map, engines[ext_engine_map]
    else
      ext = _.keys( ext_engine_map )[0]
      app.engine ext, engines[ext_engine_map[ext]]

  # Apply middleware loaded by sitefile.load_packages
  for mw in ctx.middleware
    app.use mw.passthrough


parse_simple_types = ( query ) ->

  for key, value of query
    if value in [ 'true', 'false' ]
      query[key] = Boolean value
    else if not isNaN parseInt value, 10
      query[key] = parseInt value, 10
    else if typeof value == "object"
      parse_simple_types query[key]


module.exports =
  init: init_express
  query_parser: ( query_str ) ->
    query = qs.parse query_str
    parse_simple_types query
    query
