Node Sitefile
=============
:Version: 0.0.3-demo
:Status: Development
:package: Changelog_

  .. image:: https://badge.fury.io/js/node-sitefile.png
    :target: http://badge.fury.io/js/node-sitefile
    :alt: NPM

  .. image:: https://gemnasium.com/dotmpe/node-sitefile.png
    :target: https://gemnasium.com/dotmpe/node-sitefile
    :alt: Dependencies

  .. image:: https://david-dm.org/dotmpe/node-sitefile.svg?style=flat-square
    :target: https://david-dm.org/dotmpe/node-sitefile
    :alt: Dependencies

:project:  `Misc.`_

  .. image:: https://coveralls.io/repos/dotmpe/node-sitefile/badge.png
    :target: https://coveralls.io/r/dotmpe/node-sitefile
    :alt: Coverage

  .. image:: https://secure.travis-ci.org/dotmpe/node-sitefile.png
    :target: https://travis-ci.org/dotmpe/node-sitefile
    :alt: Build

:repository:

  .. image:: https://badge.fury.io/gh/dotmpe%2Fnode-sitefile.png
    :target: http://badge.fury.io/gh/dotmpe%2Fnode-sitefile
    :alt: GIT


Sitefile enables an Express server to be quickly set up from a single configuration file called the Sitefile.
The sitefile mainly consists of a mapping of file paths or patterns that are mapped to different types of router handlers.

Primarily it was written to serve reStructuredText as HTML, but has Jade,
Stylus, Markdown and Coffee-script handlers too. In its current state it is usable
as a really simple HTTP server to use for example to read documentation of a project.
Maybe as a sketchpad for Jade, Stylus and Coffee-Script experiments.

Focus for upcoming features in on microformats to tie things together and enable
richer presentation while keeping appropiatly simple plain text file-based content.
Possibilities for future development are maybe a sort of mixed content-type wiki.



.. contents::



.. role:: todo(strong)

Intro
-----
The primary idea is to to look at a file folder as a set of hyperlinked documents,
formatted in various ways as appropiate to the task ie. some project.
Sitefile turns each file into a URL and a handler instance, based on
filepath and name patterns from the Sitefile.

It should be useful for projects that have no webserver of their own, or that
want to defer rendering/browsing of the project documentation and other resources.

Alternative solutions are explored in `Sitefile planet`_ section.



Plan
----
There are many possible useful directions:

- provide an in-browser IDE experience, possibly enabling Makefiles and other
  buildformats. Excuberant CTags.
- embedded issue browser/editor.
- 3D file viewer.
- transliterature browser.
- other web-related files: browse bookmarks, references. An simple URL carroussel/slideshow app?
- make editing sitefile easy. Maybe write json schema, and use jsonary_.
- what about tiddlywiki.

Next:

- need to integrate concept of content-type (ie. representation vs. resource) to
  deal with parametrizing the publisher (routers). Currently the routers are purposely very naively implemented to focus on a generic, flexible Sitefile schema.

- Setup some transclusion micro-protocol (over HTML+XmlHttpRequest) for dynamic branching, and mix/browser content client-side using hash-navigation, building up a client-side app essentially.

- Move to a concept of a standard file-type handler registry, posibly some
  magic. Use Sitefile to index (only) those resources that are linked together,
  likely introduce domain or site attribute (ie. specify a 'docuverse', or 'linking space' within which the hyperlinks/references can act, and which in other ways determines presentation, as apposed to the content which is in principle a set of plain text human readable and processable files).

- make some guards to determine version increment, maybe some gherkin specs.



Description
------------
The intended purpose is to implement generic handlers for misc. file-based
resources that are suitable to be rendered to/accessed through HTTP and viewed
in a web browser. For example the ReadMe file in many projects.

To do this, sitefile comes with built-in handlers that take various file formats
and publish usually a HTML equavalent over HTTP. These handlers are simply
Express middleware.

TODO: test this:

Sitefile keeps a single 'routes' object with a mapping of all URL, handlers.
The generic syntax to serve all files of a certain extension using the example
handler 'handler' is::

  _1: handler:**/*.example

The key is simply a unique string, except it needs to start with a '_' and it will be replaced
by the URL determined for each handler instance at runtime.

More elementary, the following makes so a handler 'handler' gets initialized
using one argument 'dir/for/res.example', and that will be called for requests at
the given URL path::

  /path/for/res: handler:dir/for/res.example


`sitefile` must be started from the directory where a `Sitefile.*` is located.


See Configuration_ and Specs_ for further details.



Prerequisites
-------------
- Python docutils is not required, but is the only document format available.
- Installed ``coffee`` (coffee-script) globally (see ``bin/sitefile`` sha-bang).



Installation
------------
::

  npm install -g

Or make ``bin/sitefile`` available on your path, and install locally (w/o ``-g``).



Testing
-------
::

  npm install
  npm test

Test specifications are in ``test/mocha/``.



Usage
------
In a directory containing a ``Sitefile.*``, run `sitefile` to start the server.

There are no further command line options.



Configuration
--------------
First an example in JSON format. The identical YAML format is also
supported::

  {
    "sitefile": { "version": "0.1" },
    "routes": {
      "ReadMe": "rst2html:ReadMe",
      "media": "static:public/media",
      "_docs": "du:doc/**/*.rst",
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



Examples
--------
This section works with the handlers from the `Sitefile for this project <./Sitefile.yaml>`_.

The root redirects to this ReadMe file. So does ``/index``.
There is another redirect for `./example </example>`_ to `example/main`.
Also, there are static Express middleware handlers for the following folders:

-  `public/media </media/>`_
-  `public/components </components/>`_
-  `public/example </example/>`_

The other routes are dynamic, they are expanded at run-time for any files that
exists::

  _rst2html: rst2html:**/*.rst

  _markdown: markdown:*.md

  _jade: jade:example/**/*.jade
  _stylus: stylus:example/**/*.styl
  _coffee: coffee:example/**/*.coffee
  _markdown_1: markdown:example/**/*.md

E.g. `TODO <./TODO.md>`_ or `example/script.coffee <example/script>`_.
See examples_.


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

master [*]_
  - Basic functionality; rst2html, docutils.

  f_odata
    - Exploring odata for server-side API for richer document/clients.
      Would need something Express compatible.

  f_client
    - Added Bower. Experimenting with polymer.
    - Want to get Polymer core-scaffold running somehow.
      See examples_ and `Polymer Getting started <doc/polymer>`_.
    - `Testing prism.js </src/example/polymer-custom>`_  but does not seem to be working correctly.

  f_sitebuild
    - Compiling a sitefile to a distributable package.
      Trying to call handers directly, not usable yet.

      Maybe scraping from some edit-decision-list [EDL] generated from sitefile directly is a better (faster) approach?
      But need to build and test EDL export, and have no EDL reader (transquoter, Scrow).

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

  f_gv
    - Adding graphviz to render dot diagrams.

  demo
    - Merging experimental features. Should keep master clean.

  staging_git_versioning
    - Merging versioning seed into master.

  test
    - TODO: get python docutils (grunt exec and pip?) for testenv.
    - Was building only this at travis, now building all branches. Need to fix --force tag though.


.. [*] Current branch.



Versions
--------
See changelog_.



Misc.
------
See ToDo_ document.

- TODO: browser reset styles, some simple local Du/rSt styles in Stylus.
- :todo:`maybe implement simple TODO app as a feature branch somday`
- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- :todo:`add express functions again:`
    | "connect-flash": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

- :todo:`TODO add YAML, JSON validators. tv4, jsonary. Maybe test in another
  project first.`
- TODO: site builds, packaging
- TODO: JSON editor with backend, supporting schema and hyper-schema
- Book `Understanding JSON Schema`_
- Article `Elegant APIs with JSON Schema`_

Sitefile planet
---------------
.. include:: doc/sitefile-planet.rst
   :start-line: 3



----

.. [#] `nodejs-socketio-seed <http://github.com/dotmpe/nodejs-express-socketio-seed>`_
.. [#] `docutils-ext <https://github.com/dotmpe/docutils-ext>`_
.. [#] I know of two reStructuredText (re)writers, not considering pandoc or
    XSLT approaches. But actual Du writer component implementations. Both are not
    quite there yet. One is found in the Du Subversion rst lossless writer branch, the
    other by yours truly is in [2]_.

.. _jsonary: http://jsonary.com/
.. _semver: https://github.com/npm/node-semver
.. _json-editor: https://github.com/jdorn/json-editor
.. _changelog: ./Changelog.rst
.. _ToDo: ./TODO.md
.. _examples: /example
.. _understanding json schema: http://spacetelescope.github.io/understanding-json-schema/index.html
.. _elegant apis with json schema: https://brandur.org/elegant-apis
.. This is a reStructuredText document.

.. Id: node-sitefile/0.0.3-demo ReadMe.rst

