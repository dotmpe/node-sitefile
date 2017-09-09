Gherkin BDD Feature
===================
.. include:: .defaults.rst

PHP
  [2016-12-24] Initial look at JS, PHP tooling. Seems there is no common TAP-like
  test result stream. But the parser is quite nice, given AST with line/column
  indices to literal elements.

  No nested features. One feature per file. Makes sense, or I can live with that
  while exploring other options. Tags. Outlines?

  Found a nice twig formatter, but have no tests written. [#]_
  so nothing to see yet.

JS
  Setup selenium webdriver using Chrome after example. [#]_
  FIXME: not seeing how to start up server with any hooks,
  may need to provide my own.

ToDo
  - See about setting up cucumber-js thingies;
  - Need router to stream running process at backend. Can then receive JSON
    events in client.
  - Not sure about the initial client, could set up some templates though.
    Or rather loot at source highlighting router instead.
  - Maybe browser tests. But look see for current testing of sitefile in
    `Testing Feature`.
  - Other things to test?

.. [#] https://github.com/cucumber/gherkin
.. [#] https://packagist.org/packages/emuse/behat-html-formatter
.. [#] https://github.com/cucumber/cucumber-js/blob/master/docs/nodejs_example.md

