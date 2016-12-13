
exports.up = (knex, Promise) ->
  knex.schema.createTable( 'documents', (table) ->
    table.increments('id').primary()
    table.string('path')
  )


exports.down = (knex, Promise) ->


