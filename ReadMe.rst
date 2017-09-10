Node Sitefile
=============
:Version: 0.0.7-dev
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

:project:

  .. image:: https://coveralls.io/repos/dotmpe/node-sitefile/badge.png
    :target: https://coveralls.io/r/dotmpe/node-sitefile
    :alt: Coverage

  .. image:: https://secure.travis-ci.org/dotmpe/node-sitefile.png
    :target: https://travis-ci.org/dotmpe/node-sitefile
    :alt: Build

  ..
     .. image:: https://img.shields.io/github/issues/dotmpe/node-sitefile.svg
       :target: http://githubstats.com/dotmpe/node-sitefile/issues
       :alt: GitHub issues

:repository:

  .. image:: https://badge.fury.io/gh/dotmpe%2Fnode-sitefile.png
    :target: http://badge.fury.io/gh/dotmpe%2Fnode-sitefile
    :alt: GIT


.. include:: doc/.defaults.rst


Summary
-------
Sitefile is a local website server for (project) documentation or notebooks.
It is targetted at users/authors of plain-text, file-based content. It aims to
add hypertext capabilities to documents of the literal kind, and any other
interpreted language.

.. TODO get some screenshots here, and point to the rest of the docs.

It at as of 0.0.5-dev supports a couple of markup formats, a diagramming
languages, has some initial database support and other Node.JS native languages.

The main documentation is written in reStructuredText format for the Python
Docutils publisher. But as many other formats are available as `routers` can be
written for, currently: Markdown, Stylus, SASS/SCSS, Coffee Script, Graphviz and
others.


Quickstart
----------
Have a ``Sitefile.yaml`` or ``.json`` and fire up `sitefile` from this directory.

E.g. to serve a simple little site::

  sitefile: 0.0.5-dev
  routes:
    _my_markdown_routes: markdown:**/*.md
    _my_stylus_routes: styl:**/*.styl
    media: static:media/
    ChangeLog: docutils.rst2html:ChangeLog.rst


That's it! This expands to routes for all ``*.md`` and ``*.styl`` files, serves
anything in media at ``/media/``, and has another static URL path that renders
the changelog.

The idea is to leave as much as the aspects of the resources to some
in-filesystem object or other local service, wether a document, metadatafile or
database. That said the ``Sitefile.yml`` can also hold options, and currently
can get pretty crammed. Future plans include making routes optional, and
parameterize simple Sitefile sessions through command line arguments.

The ``Sitefile.yaml`` with `node-sitefile` and the list of routers in
``lib/sitefile/routers`` for now provides the best starting point for support.

Behind the scenes better documentation and testing is being setup. See the
dev_ docs.


.. important::

   The syntax will change for 0.1 and/or 1.0



Installation
------------
For a stale version::

  npm install node-sitefile

For the latest version, get the project (clone, download) and inside folder::

  npm install -g

Or just make ``bin/sitefile`` available on your path wherever you want.



Testing
-------
::

  npm install
  npm test

Test specifications are in ``test/mocha/``.



Documentation
-------------
There is no manual or futher guide as of now. Making Sitefile in its current
state primarily an Express based website prototype platform aimed at developers.

Versions, features, development notes and all further reading is in the
`Development Docs`_.


.. This is a reStructuredText document.

.. Id: node-sitefile/0.0.7-dev ReadMe.rst
