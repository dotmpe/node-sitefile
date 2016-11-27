(0.0.1)
  - Initial sitefile with static, rst2html and redir routers.
  - Allow stylesheet parameters for rst2html.
  - Express based server handlers. Loading routers from modules.

0.0.2
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

0.0.3-dev
  - Added project versioning scripts.

0.0.4
  - Testing project publishing scripts.
  - Added graphviz.
  - Looking at jsonary, polymer in derived branches.
  - Added scripts param for rst2html, moved most code to Du router.
  - Rewrote core to allow routers to extend Express by themselves (for `DB
    Feature`_). Added Knex/Bookshelf/API for access to SQL data.
  - Cleaned up file-to-resource heuristics and made it more consistent.

(0.0.5)
  - Rewrite for lower contexts: handler/resolver.
  - Fixed URL path query parsing.
  - Went through all of the ReadMe and split into Manual and Dev docs.
  - Renamed ``Sitefile.{yaml,json}`` `params` attribute to `options` like
    the object in the `resolver context` to keep term diversity low.
  - Added ``grunt build`` with `docco` for document generator,
    and SASS for packaging some default styles.
  - Added Twitter bootstrap, jQuery, lodash build with grunt/webpack.
    Removed old `default.js` script.
  - Refactored ``router.generate`` so it can 1. return data or data callbacks
    iso. Express handlers and 2. only extend the context w/o. providing any
    handler. See `Router feature`_

  TODO: Preparing to add `require.js`.

  FIXME: Sitefile need some knowledge of Style and Script resources, both path
  and URL. Maybe bundle them. Or better use resources exported from routers.


.. include:: doc/.defaults.rst

