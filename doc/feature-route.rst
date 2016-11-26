
Notes on the `route` attribute in extension modules. Probably consolidate with
Sitefile 0.0.5 `route` sheme.


Requirements:

- play cdn
- reuse handlers
- possibly specify type of content, and at which endpoints
- standalone use: Sitefile route/... specs for components, JSON pointers [RFC6901]


Peeking at the JSON API spec for attribute names. Now try to pin down where
everything goes.

::

  name: core
  route:
    routes: .handler
    routes.res:
      data: []
      errors: []
      meta: {}
      jsonapi: {}
      links:
        self: ''
        related: ''
      included: []

  generate:
    handler: ( rctx ) ->


::

  name: require-js
  label: ""
  usage: ""
  description: ""
  defaults: {}
  route:
    lib: [
      href: 'bower:require-js/...'
      href: '//cdnjs.cloudflare.com/ajax/libs/require.js/2.1.10/require.min.js'
    ]
    # TODO: allow for name placeholder as spec, and export name as an
    # overridable optionn? sitefile_core_config_js_route= ?
    main.js: 'file.js:'
    main.json: 'file.js:'
  generate:
    config: ( ) ->
  docs:
    route:
      config:
        The ~ route holds an optional resource, it could be made easily
        available to the main script resource?
      main:
        The ~ route holds the main script, basically it passes a module mapping
        to require-js and sets off the main require/dependencies.
      lib:
        The ~ is a local route that leads to the require.js dist package to use.
    generate:
      config:
        The ~ generator can create a new require.js main file from examples, or
        restore one.


Recap in accordance with JSON API:

- make routes that provide the actual resource have a data attribute.
  make other routes relate .

JSON API example for above Sitefile components.

api.json.yaml::

    jsonapi:
      version: "1.0"
    included: []
    links:
      related: '/core/routes'

core/api.json.yaml::

    jsonapi:
      version: "1.0"

core/routes/api.json.yaml::

    jsonapi:
      version: "1.0"

    data: %ctx.routes
    links:
      self: ref( rctx )
      related: ref( ... )
  }

  ref = ( rctx ) ->
    rctx.site.base + rctx.res.name

