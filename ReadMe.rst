Node Sitefile
=============
:version: (0.0.3)
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


.. This is a reStructuredText document.

Sitefile enables an Express server to be quickly set up from a local configuration file.

It's a young project written with the intend to primarily make reStructuredText
embedded content more (readily) accessible. In its current state it is usable 
as a really simple HTTP server for documentation.
A sort of read-only wiki.
Maybe as a sketchpad for Jade, Stylus and Coffee-Script experiments.

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

  $_1: handler:**/*.example

they key gives the rule an unqiue ID. Alternatively, paths are routed
explicitly::

  /path/for/res: handler:dir/for/res.example


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
    - Want to get core-scaffold running. Need to look at router maybe.
      See examples_ and `Polymer Getting started <doc/polymer>`_.
    - `Testing prism.js </src/example/polymer-custom>`_  but does not seem to be working correctly.

  f_sitebuild
    - Compiling a sitefile to a distributable package.

  f_jsonary
    - Looking at wether to include Jsonary in master.


Versions
--------
See changelog_.


Misc.
------
See ToDo_ document.

- TODO: browser reset styles, some simple local Du/rSt styles in Stylus.
- :todo:`maybe implement simple TODO app as a feature branch somday`
- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- :todo:`add express functions again`
    | "connect-flash": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

- :todo:`TODO add YAML, JSON validators. tv4, jsonary. Maybe test in another
  project first.`
- TODO: site builds, packaging


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
.. _changelog: ./Changelog.rst
.. _ToDo: ./TODO.md
.. _examples: /example

