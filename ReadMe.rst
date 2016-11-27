Node Sitefile
=============
:Version: 0.0.5-dev
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

  .. image:: https://img.shields.io/github/issues/dotmpe/node-sitefile.svg
    :target: http://githubstats.com/dotmpe/script-mpe/issues
    :alt: GitHub issues

:repository:

  .. image:: https://badge.fury.io/gh/dotmpe%2Fnode-sitefile.png
    :target: http://badge.fury.io/gh/dotmpe%2Fnode-sitefile
    :alt: GIT


.. include:: doc/.defaults.rst

Intro
------
Sitefile is a local website server for (project) documentation or notebooks.
It is targetted at users/authors of plain-text, file-based content. It aims to
add hypertext capabilities to documents of the literal kind, and any other
interpeted language.

It at as of 0.0.5-dev supports a couple of markup formats, a diagramming
language, has some initial database support and other Node.JS native languages.



Quickstart
----------
Have a `Sitefile.yaml` or `.json` and fire up `sitefile` from this directory.

E.g. to serve a simple little site::

  sitefile: 0.0.5-dev
  routes:
    _my_markdown_route: md:**/*.md
    _my_stylus_route: styl:**/*.styl
    media: static:media/


That's it! The idea is to leave as much as the aspects of the resources to some
in-filesystem object or other local service, wether a document, metadatafile or
database. In the future more attention will be given to patterning URLs,
and supporting as detailed or broad a use case required.

The ``Sitefile.yaml`` with `node-sitefile` and the list of routers in
``lib/sitefile/routers`` for now provides the best starting point.



Installation
------------
For a stale version::

  npm install node-sitefile

For the latest version, get the project::

  npm install -g

Or make ``bin/sitefile`` available on your path, and install in PWD (w/o ``-g``).



Testing
-------
::

  npm install
  npm test

Test specifications are in ``test/mocha/``.



Versions
--------
See changelog_.



Further reading
---------------

- `Docco docs`__

.. __: /doc/literate

- `Sitefile planet <doc/sitefile-planet.rst>`_ on alternatives, similar ideas;
  status quo and prior art.

- `Manual <doc/manual.rst>`_ initial sketchbook on usage.

- `Development Docs <doc/dev.rst>`_



----

.. [#] `nodejs-socketio-seed <http://github.com/dotmpe/nodejs-express-socketio-seed>`_
.. [#] `docutils-ext <https://github.com/dotmpe/docutils-ext>`_
.. [#] I know of two reStructuredText (re)writers, not considering pandoc or
    XSLT approaches. But actual Du writer component implementations. Both are not
    quite there yet. One is found in the Du Subversion rst lossless writer branch, the
    other by yours truly is in [2]_.

.. This is a reStructuredText document.

.. Id: node-sitefile/0.0.5-dev ReadMe.rst
