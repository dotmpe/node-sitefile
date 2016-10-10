fs = require 'fs'
path = require 'path'

knex = require 'knex'

sitefile = require '../sitefile'
knex_util = require '../knex'



module.exports = ( ctx={} ) ->

  name: 'knex'
  label: ''
  usage: """
    knex:**/*.json

  Loads a JSON file to use as index to neighbouring database file, and a 
  models and migration folder resource.

  The config is passed to Knex and Bookshelf after the file and 
  migrations.directory attributes updated to reflect the correct sub-path. 
  """

  generate: ( rsctx ) ->

    sitefile.log 'Knex index:', rsctx.path
    config = knex_util.load_config rsctx, ctx

		# Initialize DB
    db = knex config
    db.migrate.latest()

    ( req, res ) ->

      res.write JSON.stringify config
      res.end()


if 'knex' is path.basename process.argv[1], '.coffee'
  console.log 'mod'

