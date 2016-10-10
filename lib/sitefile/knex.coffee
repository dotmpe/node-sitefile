path = require 'path'

# TODO: move back to knex router after inheritance is fixed for bookshelf-api
load_config = ( rsctx, ctx ) ->
  if not rsctx.path
    throw Error("Expected rsctx.path")
  config = require path.join ctx.cwd, rsctx.path
  if not config.connection.filename.startsWith '/'
    config.connection.filename = path.join(
      ctx.cwd,
      path.dirname(rsctx.path),
      config.connection.filename
    )
  if not config.migrations.directory.startsWith '/'
    config.migrations.directory = path.join(
      ctx.cwd,
      path.dirname(rsctx.path),
      config.migrations.directory
    )
  if not config.models.directory.startsWith '/'
    config.models.directory = path.join(
      ctx.cwd,
      path.dirname(rsctx.path),
      config.models.directory
    )
  return config

module.exports =
  load_config: load_config
