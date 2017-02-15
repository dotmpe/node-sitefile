
.. include:: .defaults.rst

Notes on the `route` attribute in extension modules. Probably consolidate with
Sitefile 0.0.5 `route` scheme.


Requirements:

- reuse handlers
- possibly specify type of content, and at which endpoints
- standalone use: Sitefile route/... specs for components, JSON pointers [RFC6901]


Use cases
---------

1. Static files. Uses Express middleware.

2. Third-party Content Delivery: redirect or proxy requests elsewhere.

      TODO: Using the ``cdn`` router, serve the first available resource
      (local, or global).

   Want some CDN-like router.
   Provide a list at try each before serving as resource, redirect?

   TODO: provide lists of alternative URLs
   TODO: optionally have path attribute for routers that like both URL and local
   path.

   "bootstrap": "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min"


Design
--------

Middleware and mounting
  ::

    routes:
      /html/%{res}: sfv0.html:?#
      /txt/%{res}: sfv0.txt:?#

  Maybe: a base prefix for "dynamic" files, generated from other files;
  processed, compiled, minified, transformed, included, rendered, etc.
  Its the opposite of changing the extension. But see notes on feature/baseref.

  Both methods::

    routes:
      %.html: du.html:**/*.rst#
      html/%: du.html:**/*.rst#
      # Ideas:
      # %.rst: static:**/*.rst
      # txt/%.rst: du.txt:**/*.rst#
      # %.rst: sfv0.src:**/*.rst

  Above idea on basic, but flexible 0.1-ish syntax.
  Currently each glob scan is individual. Something more intelligent maybe.

  But no abstraction of resource type yet. Only the tree of sitefile contexts.
  KISS. ``sfv0.*`` to do some specific things about routing for both
  browser clients and more programmatic access... maybe.

  Rather would abstract ideas presented in syntax a bit, extend existing ideas.
  Before making Sf more complex in features by bringing in new ideas..

  1. default routes, perhaps per profile too.. Something more fancy than
     just `sitefile ./my/alt/Sitefile.yaml`?

     Router, user config or local config (sitefile etc.) can provide.
     ::

        name: 'du'
        label: 'Docutils Publisher'
        usage: """
        """
        defaults:
          handler: 'rst2html'
          global:
            rst2html: ...
          routes:
            du.rst2html:**/*.rst
            du.rst2html:**/*.rst

     E.g.::

        sitefile [--default]
                 [--default=<profile>]
                 [--default-routes] [--routers=<router>...]

     To pick up user's Sitefile or other file than default, or
     use all routers with default routes iso. local Sitefile resp.

  2. Modes of routes::

        %.<pub-ext>: <glob>.<src-ext>
        <pub-tree>/%: <glob>.<src-ext>

     So what is 'default'? Or just call first form 'classic' and make second
     default: ``sitefile --default-routes --routers=du --classic``.


  https://stephensugden.com/middleware_guide/


Baseref
  Using changing basereferences can muck up hyperlinks, see feature/baseref.
  If the entire 'site' is mirrored, things are more pleasant. Then inserted
  bases like `html` and `txt` should just be parallel trees.


Image compositing
  Bitmap processing can be done with Imagemagick compositing. Like PlantUML
  has built-in. See http:/tools/diagram-shadows.sh.

  Use case: dot-diagram shadows
    Background: Requires two graphviz renders and an ImageMagick CLI recipe.
    Going to have convert.filter router take local options for route.
    Need to use path with params, see if glob still kicks in.


Packaging
  Not sure yet about the Sitefile dev setup even, but may integrate part of it
  with core Sitefile. Its about prototyping the very thing it is written in
  after all.

  But see other places that concern packing:

  - features/dhtml Addons
  - features/documentation
  - features/rjs



JSON API
--------
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



Resolver
--------
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
---------

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
---------
TODO: attribute resources, get back at simplicity of::

  /url/path: router:my/files/*.xxx

But with a little extra: a seperate data and renderer instance.
Using the `meta.type` router context defined in Generator_, the data
can define its own API type.

So that sitefile can do basic rendering or actions given the proper
type metadata, or router can customize.

And routers can re-use existing data endpoints.

But need to encapsulate this in a terse syntax structure.

This must work::

  _id_1: du.html:**/*.md
  _id_rst_custom_ext: du.html:**/*.rest
  _id_rst_default: du.html:

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
------------
Simply serve ``rctx.res.data`` using JSON.stringify.

