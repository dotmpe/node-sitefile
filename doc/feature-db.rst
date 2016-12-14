
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



Data
  See also x-loopback. Maybe keep al backend/auth/data-proxy-middleware out
  of Sitefile. Express is better for other middleware.
  Maybe some simple
  standardized data API, ie. the odata for the TODO app.

  But need bigger toolkit too:

  - TODO: YAML, JSON validation. Schema viewing. tv4, jsonary.
  - TODO: JSON editor, backends, schema and hyper-schema
  - Book `Understanding JSON Schema`_
  - Article `Elegant APIs with JSON Schema`_


.. include:: .defaults.rst
