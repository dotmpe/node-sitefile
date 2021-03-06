0.0.1
  - Initial sitefile with static, rst2html and redir routers.
  - Allow stylesheet parameters for rst2html.
  - Express based server handlers. Loading routers from modules.

(0.0.2)
  - Skipped version.

0.0.3-test
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

0.0.4
  - Testing project publishing scripts.
  - Added graphviz.
  - Looking at jsonary, polymer in derived branches.
  - Added scripts param for rst2html, moved most code to Du router.
  - Rewrote core to allow routers to extend Express by themselves (for `DB
    Feature`_). Added Knex/Bookshelf/API for access to SQL data.
  - Cleaned up file-to-resource heuristics and made it more consistent.

(0.0.5)
  .. See doc/dev or HACKING.md for more on upcoming versions.


(0.0.6)
  ..

(0.1.0)
  ..

(1.0.0)
  ..


.. include:: doc/.defaults.rst

