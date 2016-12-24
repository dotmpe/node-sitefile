
.. include:: .defaults.rst

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
  - See `Mocha Router docstrings`_ for annotated source.
  - TODO `app_base_sitefile Mocha test docstrings`_.

  * See also `Gherkin Feature`_ for docs on related specification markup
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


.. _app_base_sitefile Mocha test docstrings: /doc/literate/app_base_sitefile.html

