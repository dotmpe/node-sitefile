
[2016-10-10] Branch features/db-knex contains refactored Router code, and
a way to let routers register their own Express objects. This enables
using bookshelf-api, ontop of Knex and BookshelfJS. It leverages REST from
Knex databases with objects defined in JS. Knex also features migration tooling.

cons
  - dont want dependencies. sqlite3..
  - rework, redesign for core to use backend

pro
  - more effictive lookup of metadata, keeping extensible metadata. [#]_


.. [#]
    Ie. proper HTTP headers for the entity content; language, format, encoding,
    also links (rev/rel; prev/next) etc.

    See also note on links_

Data
  x-loopback
    API framework.
  ember.js
    another

  Tools
    - TODO: YAML, JSON validation. Schema viewing. tv4, jsonary.
    - TODO: JSON editor, backends, schema and hyper-schema

  - Book `Understanding JSON Schema`_
  - Article `Elegant APIs with JSON Schema`_


[2017-08-26] Meanwhile progress with above is minimal. Most recent focus:

- Bootstrap, Knockback.js, ORM; client-centric app modelling

- CouchDB, PouchDB; one server-side, the other client-centric; has sync and
  REST API.

- Musings on more middleware, componentized design at the backend. Initial
  moves to refactor and do away with the monolithic router.

  This is far less immediate than above two points, but the Sf routers for data
  are quite ad-hoc and project specific. Thinking about a way to expose the
  server endpoints, ie. JSON API, would help improving uniformaty at least at
  the data storage/query interface level and help structure the project.


Last-Modified
  ..

    XXX: The HtD extensions plan to use one JSON document DB for annotations to
    URL's. Such store is also usable to turn Sitefile routes into resources
    with metadata.

    Making Last-Modified_ a sitefile case study to get Metadata interface from CouchDB going.
    See Resources_ section within the `Route Feature`_ docs.


.. include:: .defaults.rst
