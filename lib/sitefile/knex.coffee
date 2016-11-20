path = require 'path'

# TODO: move back to knex router after inheritance is fixed for bookshelf-api,
#   or other component.
load_config = ( rctx, ctx ) ->
  if not rctx.res.path
    throw Error("Expected rctx.res.path")
  config = require path.join ctx.cwd, rctx.res.path
  if not config.connection.filename.startsWith '/'
    config.connection.filename = path.join(
      ctx.cwd,
      path.dirname(rctx.res.path),
      config.connection.filename
    )
  if not config.migrations.directory.startsWith '/'
    config.migrations.directory = path.join(
      ctx.cwd,
      path.dirname(rctx.res.path),
      config.migrations.directory
    )
  if not config.models.directory.startsWith '/'
    config.models.directory = path.join(
      ctx.cwd,
      path.dirname(rctx.res.path),
      config.models.directory
    )
  return config

module.exports =
  load_config: load_config
