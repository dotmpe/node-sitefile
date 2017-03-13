
.. include:: .defaults.rst


- Added Bower. Experimenting with polymer.
- Want to get Polymer core-scaffold running somehow.
  See examples_ and `Polymer Getting started <doc/polymer>`_.
- Working to add prism.js source-viewer.
  See `Testing prism.js </src/example/polymer-custom.pug>`_


[2016-12-13] setup `app-0` router for first prototype of base client.

Maybe once (if ever) app is extensible just use `app.base:#`?

[2016-12-27] testing prism.js. Not sure how to go about upgrading polymer.

[2017-01-07] cleaning new sitefile v0 app a bit for use, and looking at a
polymer and debugging.
would like to start a sort of console.log with visual log polyfill
for the user to monitor the app is working correctly

[2017-02-15] There's one or more clients to build, to enable navigation etc. on
a page. There's three modes there:

1. add nav by raw HTML insert/append.
   Could be a script, or HTML code. But cannot be very particular about where it
   is inserted. To ``<head/>`` would be best.

2. add nav by router,

   this requires the router itself to support adding JS/CSS.
   Like currently the markdown router uses Pug to wrap its renderings,
   and rSt has some options. This is somewhat suboptimal, the code should have a
   single location.

   Would want to indicate 1. which resources are browser viewed (and can
   be wrapped with HTML or have a DOM to insert HTML) and 2. which of those
   can process their own options.stylesheets, options.scripts etc.

3. add nav client-side,

   here we miss the egg but then complete the circle of chickens and eggs,
   iow. this only works for routers mentioned in 2. that can manage (client)
   scripts for their renderings.

   This does enable to build a HTML+JS client, like app/v0 which can then
   be used to navigate around for any resource wether HTML and with Nav or not.
   This is an important feature, but for Sf core focus needs to stay on
   essential tooling too, not just about pulling magic from the cloud.


So really leaves only option 1 for a simple, generic catch-all solution.
Option 3.b. is in place, sort of.
r0.0.7 has other client scripts though, and it would be nice to unify the
setup for so far possible, re-use stuff, have SPR, and do something sensible,
transparant and understandable.

Branches
---------
features/html5-client
  Focusses on polyfills, more advanced generic HTML-UI frameworks like
  Angular, Backbone et al.

features/dhtml
  Continues the jQ plugin and widget development.


Design
-------

..
