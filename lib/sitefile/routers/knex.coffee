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

  generate: ( rctx ) ->

    sitefile.log 'Knex index:', rctx.res.path
    config = knex_util.load_config rctx, ctx

    # Initialize DB
    db = knex config
    db.migrate.latest()

    ( req, res ) ->

      res.write JSON.stringify config
      res.end()


if 'knex' is path.basename process.argv[1], '.coffee'
  console.log 'mod'

