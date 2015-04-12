Node Sitefile
=============
Sitefile enables an Express server to be quickly set up from a local configuration file.

It's a young project written with the intend to primarily make reStructuredText
embedded content more (readily) accessible. In its current state it is usable 
as a simple really simple (and dumb) rst2html HTTP server, a read-only wiki.

.. contents:: 


.. role:: todo(strong)

Intro
-----
The main filosophy is to look at a (project) folder as a set of hyperlinked documents,
formatted in various ways as appropiate to the project. Sitefile aims to handle
only the HTML conversion and HTTP serving of these resources, as being provided 
by the project files.

It should be useful for projects that have no webserver of their own, or that
want to defer rendering/browsing of the project documentation and other resources.

Put another way, it enables notebooks and documentation projects in general to 
serve content through a browser with full multi-media and hyperlink capabilities 
without the need to set up any server capabilities beyond installing sitefile.

By using Docutils [Du] reStructuredText [rSt] a pretty amazing array of hyperlinked
document possibilities emerge. :todo:`TODO:` Sitefile provides for a pre-styled CSS file
for HTML documents published with Du. 

Sitefile is pretty young, as I'm writing this the second day of its existence.
At this point it seems it may evolve into a kind of nodemon/forever service,
maybe inherit or mimic some grunt-linke capalities. I do intend to write forks
for specific applications. Some other vapourware ideas right now are to mount sites
defined with sitefiles onto each other into one larger sitefile process. And
maybe also to distribute pluggable, modular routers using some github scenario.

Some further background reading is provided in `Sitefile planet`_ section.


Description
------------
The intended purpose is to implement generic handlers for misc. file-based
resources that are suitable to be rendered to/accessed through HTTP and viewed 
in a web browser. For example the ReadMe file in many projects.

Its main feature is a metadatafile called the Sitefile, which specifies the
routes and handlers. For example, the following is a piece of YAML formatted
Sitefile that gives a route specification for all ``*.example`` in the pwd and
below::

  $_1: handler.name:**/*.example

they key gives the rule an unqiue ID. Alternatively, paths are routed
explicitly::

  /path/for/res: handler.name:dir/for/res.example


`sitefile` must be started from the directory where a `Sitefile.*` is located.

TODO: load schema not just to validate Sitefile but to specify/generate/validate
resource handler paremeters? cf. jsonary_

See Configuration_ and Specs_ for further details.


Prerequisites
-------------
- Python docutils is not required, but is the only document format available.
- Installed ``coffee`` (coffee-script) globally (see ``bin/sitefile`` sha-bang).


Installation
------------
::

  npm install -g

Or make ``bin/sitefile`` available on your path, and install locally (w/o ``-q``).


Testing
-------
::

  npm install
  npm test

Test specifications are in ``test/jasmin/``.


Usage
------
In a directory containing a ``Sitefile.*``, run `sitefile` to start the server.

There are no further command line options.


Configuration
--------------
First an example in JSON format. The an identical YAML format is also
supported::

  { 
    "sitefile": { "version": "0.1" },
    "routes": {
      "ReadMe": "rst2html:ReadMe",
      "media": "static:public/media",
      "$docs": "du:doc/**/*.rst",
      "": "redir:ReadMe"
    },
    "specs": {
      "static": {
      },
      "rst2html": {
        stylesheets: [ './media/style/default.css' ]
      }
    }
  }

The format is determined by the filename extension.
Supported Sitefile extensions/formats:

================ =======
\*.yaml \*.yml   YAML
\*.json          JSON
================ =======

Details
'''''''''
On startup a sitefile `context` is prepared holding all internal program
variables. This context is merged with any `sitefilerc` found,
and also available as `context.static`.

XXX: sitefilerc will be described later, if Sitefile schema (documentation) is set up.
Also sitefilerc format is fixed to yaml for now.

The context will have some further program defaults set, and 
then the sitefile config is loaded from ``config/config``. 
XXX the sitefile config itself can go, be replaced by external
default context rc. There is no real use case or test spec here yet.



Properties
'''''''''''

sitefile
  The version spec for the sitefile version to satisfy. See semver_ for syntax,
  for Versions_ for values. XXX This could be replaced by a $schema key maybe.

routes (required)
  A map or table of route-id -> router-spec.

  Keys containing a '$' indicate the spec contains a glob pattern,
  instead of these keys the basename of the paths resulting from the 
  glob pattern is used as URL. 
  are not used.
  But otherwise they are used as the URL route.

specs
  Additional parameters for for each handler.
  TODO: see also sitefilerc


Specs
'''''
Specs are strings stored as values in the `sitefile.routes` metadata table.

A router-spec includes the router and handler name followed by a ':' ::

  router_name.handler_name:<handler-spec>

where each router should have a default handler name, given a shorter spec::

  router_name:<handler-spec>

What follows after the semicolon (':') is either a opaque string to be passed 
directly to the handler implementation, or an glob pattern.

XXX specs contain as little embedded metadata as possible, focus is on
providing parameters through context (or rc) first. Some URL patterning maybe
called for but currently sitefile relies on either static or (fs) glob-expanded URL
paths.

Currently the following routers are provided:

- ``rst2html``: reStructuredText documents (depends on Python docutils)
- ``du``: a new version of rst2html with support for globs and
  TODO: all docutils output formats (pxml, xml, latex, s5, html)
- ``jade``: 
- ``coffee``: 
- ``stylus``: 
- ``static`` use expres.static to serve instance(s) from path/glob spec

and 

- ``redir``\ specify a redirect FIXME glob behaviour?

For details writing your own router see Routers_.

 
:todo:`look for some versioning (definition, validation, comparison, migration) of Sitefile schema`


Extensions
-----------

Routers
''''''''
- Place file in src/dotmpe/routers/
- module.export callback receives sitefile context, XXX should return::

    name: <router-name>
    label: <title,readable-name>
    generate: ( <handler-spec>, <sitefile-context> ) ->
      ( req, res, next ) ->
        # ...
        res.write ...
        # call res.end or res.next, etc.


Branch docs
------------
master
  - Basic functionality; rst2html, docutils.

  f_odata
    - Exploring odata for server-side API for richer document/clients.
      Would need something Express compatible.

  f_client
    - Adding bower. Need to look at polymer again. And LESS/SASS et al.


Versions
--------
See changelog_.


Misc.
------
- :todo:`maybe implement simple TODO app as a feature branch somday`
- :todo:`travis-ci.org can do build testing`
- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- :todo:`add express functions:`
    | "connect-flash": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

- :todo:`TODO add YAML, JSON validators. jsonary perhaps.`


Sitefile planet
---------------
A section looking at alternatives or comparable projects from the Node.JS sphere.

.. I don't know about many Node.JS frameworks. Express obviously, but only
   heard a bit of Grunt and Yeoman. 

   I'm biased to reStructuredText since that's been my note format for over 10
   years, and have not really found anyting as expressive. 


`harp <http://harpjs.com>`_
  enables filesystem-based content for websites too, but does so in a
  project-generator type of fashion.

  Sitefile is unobtrusive, except for some configuration file.
  Also sitefile does not focus on providing an development platform,
  harp is far more extended. some concepts such as asset management (styles,
  images) are interesting.

`Meteor <https://www.meteor.com/>`_
  Like harp, Meteor is an development platform.
  Meteor especially promotes its generator/deploy mechanism.
  More than I've seen with harp though, Meteor provides for an re-integration of
  the client and backend sides, presumably using web sockets. 
  (Meteor renders client side, presumably using some web-sockets based RPC. 
  It needs add. components to render server-side for non-JS clients)

  There is no discussion on the deployment systems, and I presume this makes the
  only valid target servers meteor enabled servers. It would be great is the
  server for the integrated backend/frontend environment was portable or
  cross-compilable. See also HaXe_.

`Docutils reStructuredText <http://docutils.sourceforge.net/rst.html>`_
  It does not appear that rSt is that popular with the Node.JS crowd. 
  Even with Sphynx and the like it looks like it has not gained much traction beyond Python.

  One popular? node module is actually to `convert rst to markdown <https://nodejsmodules.org/pkg/rst2mdown>`_.

`Node.JS`
  It's so simple to aggregate rich apps with Node.JS and NPM that Sitefile unless it grows is not so much needed. 
  Even without Express and standard libraries only: https://gist.github.com/ryanflorence/701407
  And just for static files: http://www.sitepoint.com/serving-static-files-with-node-js/

  It is the richness of the finally presented document that Sitefile aims for and Node.JS and later Bower may provide.
  Mentioning bower, and about further client scripting: that extends beyond the scope
  for this project right now. See [1]_.

`node-static <http://harpjs.com>`_
  Makes easy streaming of files. Would be nice to integrate with for media centers
  with Sitefile HTML UI?

`Jingo <https://github.com/claudioc/jingo>`_
  Something to look at. Given its GIT based store and Wiki formatting this may provide for another
  interesting file-based content router.

`wiki-server <https://www.npmjs.com/package/wiki-server>`_
  "A Federated Wiki Server"


reStructured Text documenation tooling
''''''''''''''''''''''''''''''''''''''

`Sphynx <http://sphinx-doc.org/>`_
  Python documentation generator based on Du (ie. rSt to HTML, LaTex, etc.)

  Provides some additional reStructuredText directives, uses its own
  publisher chain.

`Nabu <https://bitbucket.org/blais/nabu>`_
  Document publishing using text files.

  Provides an extractor framework for regular Du transforms to turn into data
  extractors.
  Extractors are paired with storage instances, of which Nabu provides some SQL
  compatible baseclasses.
  Indexed external metadata can then by used by other systems, such as a blog
  publisher.

  Potentially, Du transforms can rewrite documents and ie. enrich references and
  various sorts of embedded metadata. 
  For a complete setup, this would require a reStructuredText (re)writer however. [#]_

`pandoc <http://johnmacfarlane.net/pandoc/>`_
  A pretty heroic "swiss-army knive" doc-conv effort in Haskell.

  It is not completely compatible with Python Docutils rSt, but does an pretty
  amazing job on converting rSt and a few dozen other formats with each other.
  Worth a mention, without it being used by sitefile (yet).

.. if they ever are usable here perhaps mention Blue-Lines, or Scrow.


Other Non-NodeJS-related Topics
'''''''''''''''''''''''''''''''''

`Markdown <http://daringfireball.net/projects/markdown/>`_
  Markdown is less well defined and in general far less capable than reStructuredText,
  but very suited for simple marked up text to HTML conversions.

  Its simplicity is only one likely cause that it is far more popular across various web-related projects.
  Commercial suites from Atlassian elaborate on a similar plain text editor formats.

`TiddlyWiki <http://tiddlywiki.com>`_
  "a non-linear personal web notebook"

  Not opened in years and never really used it, but the concept is really nice.
  May already provide some Node.JS integration.

`Jekyll <https://github.com/jekyll/jekyll>`_
  "Jekyll is a blog-aware, static site generator in Ruby"

  :via: GitHub Pages - `Using Jekyll with Pages <https://help.github.com/articles/using-jekyll-with-pages/>`_

`HaXe <http://haxe.org>`_
  Has nothing to do with publishing, but looking at deployment options it has some
  interesting feats to mention in addition to Harp, Meteor and Jekyll. 

  HaXe is an ECMA-script language with compilers for a number of other
  high-level languages, including PHP and JS. It also provides for 
  RPC setups for use on clients, and an ORM system.
  Its API is nearly cross-platform. Making it very interesting to use it for
  writing not only clients, but also servers that support a certain publishing
  stack.



----

.. [#] `nodejs-socketio-seed <http://github.com/dotmpe/nodejs-express-socketio-seed>`_
.. [#] `docutils-ext <https://github.com/dotmpe/docutils-ext>`_
.. [#] I know of two reStructuredText (re)writers, not considering pandoc or
    XSLT approaches. But actual Du writer component implementations. Both are not
    quite there yet. One is found in the Du Subversion rst lossless writer branch, the
    other by yours truly is in [2]_.

.. _jsonary: http://jsonary.com/
.. _semver: https://github.com/npm/node-semver
.. _changelog: ./Changelog.rst

