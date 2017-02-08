
.. include:: .defaults.rst

Log
----
[2016-12-13] setup `app-0` router for first prototype of base client.

Maybe once (if ever) app is extensible just use `app.base:#`?

[2016-12-27] testing prism.js. Not sure how to go about upgrading polymer.

[2017-01-07] cleaning new sitefile v0 app a bit for use, and looking at a
polymer and debugging.
would like to start a sort of console.log with visual log polyfill
for the user to monitor the app is working correctly

[2017-02-07] Deeper app/v0 testing
  - app/v0 is working okay-ish.
  - Has minimal testing in Sitefile_yaml_RequireJS
  - if possible, needs full control of baseref/reference resolving by publisher
    (in backend).

    Client needs rully resolved baseref in documents.

    Sitefile baseref feature efforts in features/baseref.

    Router baseref initial docs below.

Dev
-----
- Added Bower. Experimenting with polymer.
- Want to get Polymer core-scaffold running somehow.
  See examples_ and `Polymer Getting started <doc/polymer>`_.
- Working to add prism.js source-viewer.
  See `Testing prism.js </src/example/polymer-custom.pug>`_


Design
------
Router Baseref
  Unfortenately reference resolving is a bit of an orphan. Forgotten. Covered
  up. Even the reverend Du/rSt has no directive or publisher option that affects
  references in any way. The only inline reference expansion it knows are
  IETF RFC's, and PEP Id's. There is much potential, but also need for generic
  solutions to cover a broad set of cases.

  Requirements otoh:
    - Provide a baseref for the document, if required fully expand links to
      absolute references.
    - Use alternate schemes, ie. for things published in a browser extension use
      ``chrome://``.
    - Allow content to "travel" to other bases, iow. rewrite netpaths.
      E.g.::

        /xml/<doc>
        /html/<doc>
        /text/<doc>

    In many dynamic publishing systems, static content like marked up literal
    text will give problems here. Unless written/authored/edited exactly for
    the endpoint it is served at. The only recourse is allow for relative
    references, and in-place publishing. The latter because the rSt ``include``
    directive is also a form of link, and suffers particulary from the same lack
    of reference resolving.

  State:
    - Pre-processors are fragile, but would deliver the highest quality content.
    - In-stack publisher access might be feasible, but requires many different
      subprojects. E.g.:

        - Eclipse Mylyn / Ant for several wiki dialects to/from HTML (Java)
        - Docutils/reStructuredText to HTML (Python)
        - Native or maybe other Markdown to HTML.
        - Pandoc perhaps to cover others not in above conversions (Haskell)
        - PlantUML, Graphviz references.

    - Post processing would be even dirtier. Except for DOM accessible content
      (HTML/SVG), then it may be sub-optimal. But workable. This is the
      situation now.

    A text (pre-)processor would seem the best solution.

    I'm thinking of router that consumes yaml with regexes, and rewrites
    endpoints before the publisher gets the resource.


Related
-------
- `Router Feature`_
- `Text Markup Feature`_
- `RequireJS Feature`_


