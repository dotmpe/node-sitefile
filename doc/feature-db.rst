
[2016-10-10] Branch features/db-knex contains refactored Router code, and
a way to let routers register their own Express objects. This enables
using bookshelf-api, ontop of Knex and BookshelfJS. It leverages REST from
Knex databases with objects defined in JS. Knex also features migration tooling.

cons
  - dont want dependencies
  - rework for core to use backend

pro
  - more effictive lookup of metadata, keeping extensible metadata. [#]_


.. [#]
    Ie. proper HTTP headers for the entity content; language, format, encoding,
    also links (rev/rel; prev/next) etc.


