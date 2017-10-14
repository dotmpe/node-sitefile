HTML5 Client Feature
====================
.. include:: .defaults.rst


Sitefile's main HTML client work is done using Require.JS, and documented here.
For thoughts on the project build setup see `features/dhtml`_.


Log
----
- Added Bower. Experimenting with polymer.
- Want to get Polymer core-scaffold running somehow.
  See examples_ and `Polymer Getting started <doc/polymer>`_.
- Working to add prism.js source-viewer.
  See `Testing prism.js </src/example/polymer-custom.pug>`_

- [2016-12-13] setup `app-0` router for first prototype of base client.
- [2016-12-27] testing prism.js. Not sure how to go about upgrading polymer.
- [2017-01-07] cleaning new sitefile v0 app a bit for use, and looking at a
  polymer and debugging.
  would like to start a sort of console.log with visual log polyfill
  for the user to monitor the app is working correctly
- [2017-02-15] Three modes of app HTML handling. [2017-10-14] Moved to
  `features/dhtml`_. Any mode that works will do. Client is still not very
  friendly.
- [2017-09-09] See also `component`_ and `module`_ source docs
- [2017-10-14] Cleaning up here, moving bits to `features/dhtml`_.
  Now documenting main setup approaches here.

Design
------
Documenting bootstrap approaches for Require.JS clients.

app/v0
  The client is enabled by:

  - add app/v0 route to rendered sf-v0.pug
  - add rjs.config and rjs.main app routes to create require.js bootstrap JS
  - set Sitefile options for app/v0 to the require.js app JS route
  - add key/value meta options to sf-v0.pug tpl route, to configure app via
    HTML(5) meta elements.

The main philosophies are:

1. components making up the app are defined by meta settings
2. components define their own dependencies completely

Downsides:

1. meta values are opaque strings, requires coming up with scheme for storing
   id's or structured data
2. client structure is not prescribed, no framework for MVC etc.
   Had to design for sitefile v0 some minimal lifecycle events to sync
   components and DOM/resource loading wihtout it its just not usable.

Moving closer to modern HTML concepts like webcomponents and polyfill would
improve the situation.

app/v0-sf-rjs.html
  Prototype for client leveraged from single as-is config (JSON/YAML).
  Generates HTML and Require.JS config endpoints based on pattern route.

  [2017-10-14] Added new handler ``boot`` to `rjs`_, loading dta from
  lib/sitefile/client/sf-v0.yaml. Moving all rjs config, and the separate
  JS/HTML routes from Sitefile to separte file scheme.

The philosophy amends the `app/v0` setup:

3. move configuration from Sitefile spec and options (rawhtml stuff like
   client, script, link and meta) to as-is files.

And also allows to further structure app using metadata if some scheme proves to
be practical.

For this to happen, need to build out implementation in `deref`_ and in
particular design for local and remote resource handling. See `features/http`_.


Branches
---------
features/html5-client
  Focusses on polyfills, more advanced generic HTML-UI frameworks like
  Angular, Backbone et al.

features/dhtml
  Continues the jQ plugin and widget development.
