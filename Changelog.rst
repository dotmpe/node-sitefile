.. include:: .defaults.rst
.. See doc/dev/<version>.rst for preliminary log with dev notes and current
   focus.

r0.0.1_
  .. _0.0.1:

  - Initial sitefile with static, rst2html and redir routers.
  - Allow stylesheet parameters for rst2html.
  - Express based server handlers. Loading routers from modules.

(0.0.2)
  - Skipped version.

(r0.0.3_)
  .. _0.0.3:

  * Added project versioning scripts and other build scripts.
    But did not end up with cleanly installable project.

  - Added support for dynamic routes with globs.
  - Added automatic folder-default redirection.
  - Implemented some Jasmine tests.
  - Using Grunt for code delinting, testing.
  - Automatically loading required routers (based on sitefile) only.
  - Fancy colors for stdout.
  - JSON path dereferencing in Sitefile.
  - Started Markdown, Jade (now Pug), Stylus and Coffee-Script routers.
  - Testing if docutils and other dependencies present,
    degrading functionality gracefully.
  - Added TODO file. Looking if markdown is suitable format.

r0.0.4_
  .. _0.0.4:

  - Testing project publishing scripts.
  - Added graphviz.
  - Looking at jsonary, polymer in derived branches.
  - Added scripts param for rst2html, moved most code to Du router.
  - Rewrote core to allow routers to extend Express by themselves (for `DB
    Feature`_). Added Knex/Bookshelf/API for access to SQL data.
  - Cleaned up file-to-resource heuristics and made it more consistent.

(r0.0.5_)
  .. See doc/dev or HACKING.md for more on upcoming versions.
  .. _0.0.5:

  Includes router URL base feature that is not mature enough.

(r0.0.6_)
  .. _0.0.6:

  Started a handler context rewrite.

(r0.0.7_)
  .. _0.0.7:

  - Bypassed r0.0.5 feature changes to get back at stable release.
  - New routers:

    - ``sh.ls`` and ``sh.tree``
    - ``res.load-file`` (renamed ``data`` to ``res`` since there is alreay
      a builtin ``data``)

  - Removed ``http.site`` router.
  - Renamed routers:

    - ``{du->docutils}``
    - ``{md->markdown}``
    - ``{gv->graphviz}``

  - Started ``0.1`` version prefix to experiment with component versioning.
  - Using `neodoc`_ for argument parser now.
  - Added config for remote sites, to set CORS.
  - Started on extending r.js client features, dependencies.
    Added PouchDB component.
  - New extension types: ``middleware`` and ``context-prototype``.
  - Doc updates. Revision and reshuffle for some docs. Brought main feature
    categories back to 3.
  - Added CDN entries for THREE.js, D3.
  - Building out Sitefile v0 client classes.

    Added microformats for ``live-code``, ``a[href]``.

  - Added Express version to context, include with server start log line.
  - New ``boot`` handler for `features/rjs`_.

  - Repeat of earlier issues with Mocha-Coffeescript. See doc/feature-build

(0.0.7-dev)
  - Rewrite rawgit.com refs to cdn.jsdelivr.net

(0.1.0)
  .. _0.1.0:

(1.0.0)
  .. _1.0.0:


.. footer::

   NB: Versions enclosed in round brackets indicate unreleased, either planned
   or missed, skipped versions.

.. _DB Feature:              doc/feature-db.rst
.. _features/rjs:            doc/feature-rjs.rst

.. _neodoc: //github.com/felixSchl/neodoc
