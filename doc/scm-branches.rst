
master [*]_
  - Basic functionality; static, redir routers.
  - Document handlers: rst2html, docutils, markdown.
  - Scripts: CoffeeScript, Shell.
  - PNG Diagrams: Graphviz.
  - CSS Stylesheets: Stylus.
  - HTML/XML template expressions: Pug (formerly Jade).

  features
    db-*
      Looking for database to HTTP endpoints, but also may want to support
      a backend in core. See `DB Feature`_ docs.

      db-knex
        Bookshelf is an ORM using Knex. Look for an HTTP API.

      db-odata
        - Exploring odata for server-side API for richer document/clients.
          Would need something Express compatible. But can create another server
          and implement only some fancy redir router for sitefile.

        odata-server
          Define entity and set, like backbone, and serve. MongoDB or SQLite.
          See example/odata. Mostly OData-2.0, some 3.0.

        node-odata
          Looks similar. OData-4.0. MongoDB only but other common systems planned
          (0.7.12).

        n-odata-server
          Multiple backend, lightweight, nearly complete OData API (v2). JSON.
          But for the lookback framework. Maybe a nice supplement to serve data
          besides Sitefile service. Created `x-loopback` project

        First look at Loopback framework in `x-loopback`.
        Keep focus for Sitefile dev. on client/middleware.

    Command Line
      f_sitebuild
        - Compiling a sitefile to a distributable package.
          Trying to call handers directly, not usable yet.

          Maybe scraping from some edit-decision-list [EDL] generated from sitefile directly is a better (faster) approach?
          But need to build and test EDL export, and have no EDL reader (transquoter, Scrow).

    Routers
      html5-client
        - Added Bower. Experimenting with polymer.
        - Want to get Polymer core-scaffold running somehow.
          See examples_ and `Polymer Getting started <doc/polymer>`_.
        - Working to add prism.js source-viewer.
          see `Testing prism.js </src/example/polymer-custom.pug>`_

      f_jsonary
        - Looking at jsonary as a client-side JSON schema renderer/editor.

      f_ph7{,_node}
        - Wanted to run simple PHP files using sitefile.
          Tested ph7-darwin NPM packages. Seems to perform same as ph7.
          No stdout reroute yet so unusable, but functional.

      f_json_editor
        - Added JSON-Editor_ with one schema, no server-side api yet.
          Need to look at hyper-schema.

      f_bootstrap
        - Added bower things for bootstrap, testing with server-side Jade pages.

      f_gv (merged)
        - Adding graphviz to render dot diagrams.

  demo
    - Merging experimental features. Should keep master clean.

  staging_git_versioning
    - Merging versioning seed into master.

  test
    - TODO: get python docutils (grunt exec and pip?) for testenv.
    - Was building only this at travis, now building all branches. Need to fix --force tag though.


.. [*] Current branch.


.. _json-editor: https://github.com/jdorn/json-editor
.. _DB Feature: docs/feature-db

