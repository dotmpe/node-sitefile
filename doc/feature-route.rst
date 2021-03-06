
.. include:: .defaults.rst

Notes on the `route` attribute in extension modules. Probably consolidate with
Sitefile 0.0.5 `route` schema.


Requirements:

- reuse handlers
- possibly specify type of content, and at which endpoints
- standalone use: Sitefile route/... specs for components, JSON pointers [RFC6901]


Status: all of this below is design phase, draft material. In the same general
direction as dev, but not up to date. See test/mocha

Use cases
------------------------------------------------------------------------------

1. Static files
    TODO: test setup.

2. Third-party Content Delivery
      TODO: Using the ``cdn`` router, serve the first available resource
      (local, or global).

   Want some CDN-like router.
   Provide a list at try each before serving as resource, redirect?

   TODO: provide lists of alternative URLs
   TODO: optionally have path attribute for routers that like both URL and local
   path.

   "bootstrap": "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min"

3. Maybe: provide a base dir prefix for "dynamic" files, ie. those generated
   from other files.

   But want to override back to normal, on maybe per-route basis?
   Use case: some files are checked into SCM, or expected in the working tree.

   But for most generated files, don't pollute?

   Maybe alternatively track and cleanup dynamic files on closedown or a special
   command.

4. TODO: Add shadows to DOT diagrams.

   See http:/tools/diagram-shadows.sh

   Requires two graphviz renders and an ImageMagick CLI recipe.

   Going to have convert.filter router take local options for route.
   Need to use path with params, see if glob still kicks in.

   And have graphviz accept more params.


JSON API
------------------------------------------------------------------------------
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


Implementations
------------------------------------------------------------------------------
Applies partially to r0.0.6, and partially to master/dev/r0.0.7 branch.

Resolver
______________________________________________________________________________
sitefile.Router.Base.resolve turns a parsed Sitefile route spec into a route
context. This looks like::

  name: <name of resource path>
  route:
    name: <name or router module>
    handler: <name of handler generator for router>
    spec: <arguments to router.generator>
    options: <defaults + parsed spec + parsed query* >
  res:
    data: [] or {} or ...
    jsonapi: version: "1.0"
    meta:
      type:
    errors: []
    links:
      self: //location
      related: //ref

Options are currently extended at request time from the query arguments.
XXX: need some more structured scheme for route.spec, URL.query -> options

XXX: the jsonapi and following res attributes are taken from the `JSON API`
specs. Not implemented, see Generator_ spec below.


Generator
______________________________________________________________________________

sitefile.Routers.generator currently implements resolving to an Express handler
given a route context.

A generator can return a handler function, a router context extension object,
or nothing.

In the latter case it is assumed the router has added its own middleware/routers
to the Express instance.

For the former two, sitefile handles adding the route to Express.
If it is an object, it always extends the route context with it.

To turn the object into a route handler it must have an data or meta.type attribute
at `ctx.res`. Iow. the extension object at least looks like either::

  res: data: [ 1, 2, 3 ]
  res: meta: type: ''

For data with no type is known, the builtin router named 'data' is used.
TODO: If a type is given (set to `rctx.res.meta.type` ) load/look at ...?

The data is an instance known at initialization time, or a callback accepting
the resource context to return the instance data per route request.

Resources
______________________________________________________________________________
TODO: attribute resources, get back at simplicity of::

  /url/path: router:my/files/*.xxx

But with a little extra: a seperate data and renderer instance.
Using the `meta.type` router context defined in Generator_, the data
can define its own API type.

So that sitefile can do basic rendering or actions given the proper
type metadata, or router can customize.

And routers can re-use existing data endpoints.

But need to encapsulate this in a terse syntax structure.

So iso.::

  _foo: foo:**/*.foo

maybe::

  **/*.foo: foo:?meta.type=foo.Foo
  **/*.foo: foo.view:?strip-ext=true;data=.

  **/*.bar: bar.view:?strip-ext=false;data=**/*.foo

Leave URL path out for 1-on-1 mappins to filesystem.
Ie. the router spec first argument is taken from the `rctx.name`, and the spec
(a file glob) used ID name.

See `Base.resources`__ comment too.

.. __: http:/doc/literate/Router.html#section-6


builtin.data
______________________________________________________________________________
Simply serve ``rctx.res.data`` using JSON.stringify.


Related
-------
- `Text Markup Feature`_
- `HTML5 Client Feature`_


