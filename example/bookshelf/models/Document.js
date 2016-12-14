var bookshelf = require('bookshelf')(knex);

// TODO: fork bookshelf-api and see about extending it.
module.exports = bookshelf.Model.extend({
  tableName: 'documents',
  hasTimestamps: []
});

