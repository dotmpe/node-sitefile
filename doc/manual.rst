Sitefile Manual
===============
For node-sitefile.

.. contents::

.. include:: .defaults.rst


Sitefile enables an Express server to be quickly set up from a single
configuration file called the Sitefile.
The sitefile mainly consists of a mapping of file paths or patterns that are
mapped to different types of router handlers.

Primarily it was written to serve reStructuredText as HTML, but has Pug, Stylus,
Markdown and Coffee-script handlers too. In its current state it is usable as a
really simple HTTP server to use for example to read documentation of a project.
Maybe as a sketchpad for Pug, Stylus and Coffee-Script experiments.

Focus for upcoming features in on microformats to tie things together and enable
richer presentation while keeping appropriately simple plain text file-based
content. Possibilities for future development are maybe a sort of mixed content
-type wiki.




Intro
-----
The primary idea is to to look at a file folder as a set of hyperlinked documents,
formatted in various ways as appropriate to the task ie. some project.
Sitefile turns each file into a URL and a handler instance, based on
filepath and name patterns from the Sitefile.

It should be useful for projects that have no webserver of their own, or that
want to defer rendering/browsing of the project documentation and other resources.

Alternative solutions are explored in `Sitefile planet` section.



Prerequisites
-------------
- Python docutils is not required, but is the only document format available.
- Installed ``coffee`` (coffeescript) globally (see ``bin/sitefile`` sha-bang).


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


Usage
------
In a directory containing a ``Sitefile.*``, run `sitefile` to start the server.

There are no further command line options and only a few env settings.
``config/config.coffee`` is required and can be used to set the sites hostname/port as well::

  module.exports =
    default: site: {}



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

  _pug: pug:example/**/*.pug
  _stylus: stylus:example/**/*.styl
  _coffee: coffee:example/**/*.coffee
  _markdown_1: markdown:example/**/*.md

E.g. `TODO`_ or `example/script.coffee <example/script>`_.
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
  or ChangeLog_ for values. XXX This could be replaced by a $schema key maybe.

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

Current situation/plan::

  _<route-id>: <router>:<path-or-glob>

  path$<param>/path: <router>:<pg>

  /path/literal.ext: <router>:<pg>

  /prefix/^: <router>:<pg>

TODO: no prefixing tested yet. Also see `Route Feature`_ docs.


Mapping exts:

  _<route-id>.<ext>: <router>:<pg>.<ext>

  reg:
    <ext>: <mime>
    txt: text/plain


XXX specs contain as little embedded metadata as possible, focus is on
providing parameters through context (or rc) first. Some URL patterning maybe
called for but currently sitefile relies on either static or (fs) glob-expanded URL
paths.

Currently the following routers are provided:

- ``rst2html``: reStructuredText documents (depends on Python docutils)
- ``du``: a new version of rst2html with support for globs and
  TODO: all docutils output formats (pxml, xml, latex, s5, html)
- ``pug``:
- ``coffee``:
- ``stylus``:
- ``static`` use expres.static to serve instance(s) from path/glob spec

and

- ``redir``\ specify a redirect FIXME glob behaviour?

For details writing your own router see Routers_.




Customizations
---------------


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


