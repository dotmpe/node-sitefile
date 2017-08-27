Route Feature
=============
.. include:: .defaults.rst


Notes on the `route` attribute, and on the routing concepts of sitefile.


[2017-08-27] Started the Implementation section to home extraneous source docs.

[2017-06-11] Lots is said below an all kinds
of related or unrelated aspects, of dense concept of routes, and packing.

Meanwhile 1. routes implementation still needs revision, 2. are not adequate to
represent groups of resources and thus ie. pm2-apps.json and other subformats
emerge with dedicated routers, which may or may not expose their sub
routes in a common structural fashion suited for inspection and re-use.

Yet it appears that a Sitefile based, locally extended container for DHTML may
be a preferable way to leverage first serving reports, and later more deeper
structural and dynamic data for projects and service container volumes.

But for reusable, packaged routes and configs, Sitefile may want to step in with
a more generic YAML/JSON format to define resource groups in metadata.
This also reflects on the need to have a metadata annotation outline for
prototypical data, ie. files like ReadMe or other local asis data.
This is where Htd stepped in with package.yml.

So both Sitefile, and package are candidates for package metadata, and may in
turn have entries that reference other metadir or metadata file schemes.

For sitefile though, the intention is to move more towards a middleware oriented
view with composite sessions and resources iso. keeping within the discrete
parallel route-router-file chain setup in the end.

----

.. contents::

.. TODO: Probably consolidate with Sitefile 0.0.5 `route` scheme.


Requirements:

- reuse handlers, or something of the endpoints, somehow.. data, metadata, with
  or without envelope (HTTP, HTML, ..)

- possibly specify type of content, and at which endpoints
- standalone use: Sitefile route/... specs for components, JSON pointers [RFC6901]


Design
--------
The ``route`` attribute is an essential part of Sitefile.

To do it justice requires to touch on pre-established technologies: file
storage, and HTTP addressing.

That should then result in a section on the class or classes or routing that
sitefile supports.

TODO: Notes on the implementation, verbose listings etc. below should move to
inline code docs I guess, or specs/features. Version dev notes. Elsewhere.


Prior Art
~~~~~~~~~
Routers or Middleware
  To Connect [#]_ (and Express), we deal with request resolving and at the basic
  level with middelwares through which the request is run::

    app.use ( req, res, next ) -> ... # generic middleware
    app.use 'ref', ( req, res, next ) -> ... # mounted middleware

  The key to a middleware is that it must hand of the request to the `next`
  middleware (handling of the request and response is possible but optional).
  Whereas routers are characterized by the requirement that they have to finish
  some kind of response (or the app hangs).

  To the framework there is no difference between the two, but note the
  lifecycle: with middlewares e.g. the ``req.route`` will not have been resolved
  yet.

  See also [#]_ and [#]_.


Mount
  Connect introduces the concept of mounts for handlers (middlewares or routes).
  To Connect, mounted handlers are those that resolve prefixes. Any address
  request starting with, or just consisting of the literal string is passed to
  the handler instance.

  Express also does patterns and regular expressions, to match additional
  sets of addresses to single handler instances. And with parameters derived
  from the address.


Filesystem
  Sitefile site-structured is tightly coupled to the filesystem. So some aspects
  of it need ot be addressed.

  First of all, this coupling is not a requirement. It should be a convenience,
  and with flexibility to overrule, customize.
  E.g. provides a most direct way to work with references in documents.

  But contrary to filesystems, with Express or Connect things like this are
  possible::

    app.use "path/", <some-resource>
    app.use "path", <some-other-resource>

  Another convenience, and not a requirement, is using filename extensions.
  A concept almost as old command-line shells, and with as many problems.
  It is not mentioned (much or formally I think) in the HTTP or URL specs.
  But a key point to sitefile, and it gets even fuzzier considering the
  implications of the base-ref.

  TODO: ref or discussion on mapping of ext here


URL (uniform addressing)
  Baseref
    Using variable bases for references mucks up hyperlinks.
    See feature/baseref branch.

    If the entire 'site' is mirrored, things are more pleasant. Then inserted
    bases like `html` and `txt` should just be parallel trees.
    This requires the concept of 'entire site', and di

  URL-path structure
    Neither HTTP nor URL specs place restrictions on the path, expect for:

    - '?' starts the query part, and '#' the fragment
    - '/' separates path elements, and also functions as root element
    - ';' separates arguments or parameters that each element of the path can have

    Based on this, a hierarchy can be established.

    For security purposes the concept of neighbouring and nested resources
    can be exploited to restrict access from one path-prefix to another.

    But that is as far as the interpretation of the URL elements can go.

  URL-path parameters
    Path parameters are rarely seen in the wild, and this obscurity may come
    with its downsides. But consider the following::

      /user;id=1/document;id=2

    Iso. for example::

      /user/document?uid=1&id=2

    Or even the 'SEO friendly'::

      /user/1/document/2

    The readability of the latter seems great, and it looks clean. But as an
    expression of hierarchy it is hopeless. This is inherent of HTTP
    addressing.


Addressing
~~~~~~~~~~
Onto addressing in Sitefile.

The pre-0.1 schema for ``route``, and its relation to concepts in sitefile has
gotten convoluted. And requires revision. Here is the established syntax::

    routes:
      _id: router.id/to/handler:route-spec#...
      /path: "

Which ofcourse is sugar for and partly reminiscent of the Express statements
in `Routers, Middleware`. On this, a proper layering is needed of:

- the dynamic, patterned address sets derived from glob specs, and the like
- types of resources and degrees of handling them

Some endpoints are data, e.g. generic map/list structures from a YAML or JSON
context, or some other service. Handing them to the client in a generic way
will suffice, and enable lighter routers. (Relieve of all the different
methods except when required for the same).

On the other hand, the identity (and/or/vs. address) needs further
consideration.

A first class type to express a patterned set like a local
filesystem glob spec..

But also classes of resources.

And flipping the syntax around::

    routes:
      path/%.rst: sfv0.html:?#
      my/file.txt: sfv0.txt:?#

The router arguments are entirely free, can still follow some structure.
But the keys are now different types of resource sets by themselves, regardless
of the router. Also router arguments can refer to routes by the exact key,
plainly and nicely.

Next some implied types are needed. Optionally the standard behaviour above
needs to be customized.


Using mount to differentiate format::

    routes:
      /html/%{res}: sfv0.html:?#
      /txt/%{res}: sfv0.txt:?#

Both methods::

    routes:
      %.html: du.html:**/*.rst#
      html/%: du.html:**/*.rst#
      # Ideas:
      # %.rst: static:**/*.rst
      # txt/%.rst: du.txt:**/*.rst#
      # %.rst: sfv0.src:**/*.rst

Currently each glob scan is individual.

Rather would abstract ideas presented in syntax a bit, extend existing ideas.
Before making Sf more complex in features by bringing in new ideas..


Middleware and mounting
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


Versioning
~~~~~~~~~~
While introducing new behaviour, the old should be deprecated with
consideration.

The version value is already there.
Adding the ``bwc`` attribute::

  sitefile: 0.1
  routes:
    ...
  bwc:
    sitefile: 0.0.10
    routes:
      ...

The ``bwc`` is not supported yet (0.0.7-dev).
Looking at versioning the interface, important is the stability of the dev
versions. Added ``0.1`` prefix to experiment with a more modular interface.


See also:

- `Packaging Feature`_
- `Build Feature`_


JSON API
~~~~~~~~
Peeking at the JSON API spec for attribute names.

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

Recap:

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


Implementation
--------------

Context
-------

  TODO: add IoC to replace mixin component structure, and cleanup context
  implementation in nodelib.

  Add functions to do lib to module mapping, and lib deps.


Resolver
~~~~~~~~
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
~~~~~~~~~

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
~~~~~~~~~

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


Associating metadata with instances and sets of router contexts is not entirely
straightforward in the current setup. Ideally the data is put to the headers
of the response, and ready when the router handler starts.

Trying to solve this in middleware will need a separate resolve loop to get at
the context instance in case of pattern routes. Because the route is not
resolved yet at middleware time. And I could not find any Connect.js event that
would. Except ``end``, which is too late.

Also, serializing to headers may not be the best way to keep the data. Rather
integrating a new prototype and/or structure with the router context is a better
fit for the setup.

..

  TODO: metadata for resources by URL.

  See `Sitefile Metadata Middleware`_.

  Depends on `Sitefile CouchDB Metadata Context-Prototype Mixin`_.



builtin.data
~~~~~~~~~~~~
Simply serve ``rctx.res.data`` using JSON.stringify.


----

.. [#] https://github.com/senchalabs/connect#readme
.. [#] https://stephensugden.com/middleware_guide/
.. [#] https://expressjs.com/en/guide/using-middleware.html



Use cases
---------

1. Static files. (Uses Express middleware.)

     TODO: support/test::

       <dynamic-part>: static:<fnmatch>


2. Third-party Content Delivery: redirect or proxy requests elsewhere.

      TODO: Using the ``cdn`` router, serve the first available resource
      (local, or global).

   Want some CDN-like router.
   Provide a list at try each before serving as resource, redirect?

   TODO: provide lists of alternative URLs
   TODO: optionally have path attribute for routers that like both URL and local
   path.

   "bootstrap": "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min"

