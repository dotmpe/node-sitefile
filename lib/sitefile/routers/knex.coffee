fs = require 'fs'
path = require 'path'

sitefile = require '../sitefile'
knex_util = require '../knex'



module.exports = ( ctx={} ) ->

  try
    knex = require 'knex'
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err


  name: 'knex'
  label: ''
  usage: """
    knex:**/*.json

  Loads a JSON file to use as index to neighbouring database file, and a
  models and migration folder resource.

  The config is passed to Knex and Bookshelf after the file and
  migrations.directory attributes updated to reflect the correct sub-path.
  """

  defaults:
    default: {}
    sql: route: options: cache: true

  generate:

    # XXX: initial sketch on non-stream endpoints

    # Data endpoint: Prepare Knex session on resource context
    db: ( rctx ) ->
      sitefile.log 'Knex DB:', rctx.res.path
      sqlctx =
        knex:
          config: knex_util.load_config rctx, ctx

      # Initialize and update DB
      sqlctx.knex.db = db = knex sqlctx.knex.config
      knex_util.update sqlctx.knex, ctx
      sqlctx

    # Data endpoint: the spec must lead to a JS/Coffee file to accept Knex
    sql: ( rctx ) ->
      sitefile.log 'Knex SQL:', rctx.res.path
      #ctx._routers.generator('.db', rctx) rctx
      rctx.res.sqlcb = require( './'+ rctx.res.path )
      if rctx.res.options.cache
        res:
          data: rctx.res.sqlcb(rctx.knex.db, rctx)
      else
        res:
          data: ( rctx ) -> rctx.res.sqlcb(rctx.knex.db, rctx)
     
    # Document endpont: serve config JSON
    default: ( rctx ) ->
      sitefile.log 'Knex index:', rctx.res.path
      config = knex_util.load_config rctx, ctx

      # Initialize and update DB
      db = knex config
      # FIXME: db.migrate.latest()


      sitefile.log 'Knex index:', rctx.res.path
      sqlctx =
        knex:
          config: knex_util.load_config rctx, ctx

      # Initialize and update DB
      sqlctx.knex.db = knex sqlctx.knex.config
      knex_util.update sqlctx.knex, ctx

      ( req, res ) ->

        res.write JSON.stringify config
        res.end()


if 'knex' is path.basename process.argv[1], '.coffee'
  console.log 'mod'

