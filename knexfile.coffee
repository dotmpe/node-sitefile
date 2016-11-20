# Update with your config settings.
path = require 'path'

dev = require "./example/bookshelf/knex.json"

dev.migrations.directory = path.join __dirname, 'example/bookshelf',
  dev.migrations.directory


module.exports =

  development: dev

