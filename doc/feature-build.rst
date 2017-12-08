Build Feature
=============
.. include:: .defaults.rst

- Everything related to the project build and packaging, dist plans.
- Keeping docker highland build docs apart in `features/docker`_.
- See also `features/rjs`_ for more specific, and `features/packaging`_.
  for more generic docs.


Documentation
-------------
- Want to look at JSDoc features. http:/doc/api

See also
  - `Gherkin BDD Feature`_

Using readthedocs.io for serving static docs. (docs__)
Its a sphinx style build, whereas Markdown in general is more popular. So
maybe a bit at a disadvantage.

Issues:
Sphinx leaves ``.rst`` in doc references. Cannot find any config to deal with
this [#]_, and also using .defaults files really only works with either a fixed
URL base or .defaults files per-dir. Maybe better of generating them.
FIXME: But sitefile.routes handling code is not entirely suited.. yet.


.. [#] <http://www.sphinx-doc.org/en/stable/config.html>
.. __: http://docs.readthedocs.io/

Literate and Annotated Source
_____________________________
Using Docco to generate side-by-side HTML views of source code and comments.

Note: This is not implemented as router but special build setup and route config.

Multi-Line comments
''''''''''''''''''''
Docco does not support CoffeeScript multi-lines. [#]_
Giving issues with many comments currently.

.. [#] 2012, wrt. to CoffeeScript multi-line or block comment support
   <https://github.com/jashkenas/docco/pull/72#issuecomment-8199556>
   <https://github.com/jashkenas/docco/issues/29>

Document ID's
'''''''''''''
Docco uses the file basename as unique identifier, overwriting previous refs.
I like this, but need to draw the line at different extensions. ``docco-plus``
supports multiple extensions, but also seems to add/keep the full path.


Stylesheets
-----------
Use SASS predominatly at the moment. Want to parameterize later.

Note: the ``@source`` directive is left as-is by the current processor, if the
referred path has ``.css``. Ie. use another extension (``sass``, ``css3``) to
process server-side.


Build system
-------------
Gruntfile for main targets, using gulp to test some other setups.

- Code de-linting / static analysis: jshint, coffeelint, yamllint
- Mocha test runner
- Docco coffee to HTML documenter
- SASS complication
- Pass-through exec calling futher sh-based tooling


Testing
-------
Mocha Router Examples
  Both the client and server tests have hardcoded dependencies. The client can
  get off without dependency management, simply by loading additional script
  resources into the current page. The server however has to pre-load
  globals and needs some sort of dependency injection. Currently the
  ``mocha`` router hardcodes the chai and Cow dependency.

  To re-run mocha in the same Node process, the router needs to clear
  the testcase require.cache entries before adding::

        mocha = new Mocha()
        if testcase of require.cache
          delete require.cache[testcase]

  - FIXME: Reporters are not very nice, requiring to hack stdout?
    see also Mocha #1457.

  javascript-cow-class
    - `mocha client test example route </mocha/client/example/javascript-cow-class.js?suffix=-test>`_
    - `mocha server test example route json-stream reporter </mocha/server/example/javascript-cow-class.js?suffix=-test&reporter=json-stream>`_
    - `mocha server test example route json reporter </mocha/server/example/javascript-cow-class.js?suffix=-test&reporter=json>`_
    - `mocha server test example route list reporter </mocha/server/example/javascript-cow-class.js?suffix=-test&reporter=list>`_
    - `mocha server test example route markdown reporter </mocha/server/example/javascript-cow-class.js?suffix=-test&reporter=markdown>`_
    - `mocha server test example route TAP reporter </mocha/server/example/javascript-cow-class.js?suffix=-test&reporter=tap>`_

  javascript-bookmark-class
    - `mocha client test example route (coffeescript) </mocha/client/example/javascript-bookmark-class.js?suffix=-test>`_
    - `mocha server test example route (coffeescript) </mocha/server/example/javascript-bookmark-class.js?suffix=-test>`_


  - `List of mocha reporters`_
  - See `Mocha Router`_ for annotated source.
  - TODO `app_base_sitefile Mocha test`_.

  * See also `Gherkin BDD Feature`_ for docs on related specification markup
    format.

  The same Mocha client example, but included statically as reStructuredText raw HTML:

  .. raw:: html

        <link href="/vendor/mocha.css" />

        <div id="mocha"><p><a href=".">Index</a></p></div>
        <div id="messages"></div>
        <div id="fixtures"></div>
        <script src="/vendor/mocha.js"></script>
        <script src="/vendor/chai.js"></script>
        <script src="/vendor/sinon.js"></script>
        <script src="/example/javascript-cow-class.js"></script>
        <script>mocha.setup('bdd')</script>
        <script src="/example/javascript-cow-class-test.js"></script>
        <script>mocha.run();</script>
