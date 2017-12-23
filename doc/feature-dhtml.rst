DHTML Build Feature
====================
.. include:: .defaults.rst


This is on the design regarding client-centric, HTTP/web-tech supported client
and how to build it. For the current sf-v0 Require.js app, see `HTML5 Client
Feature`_ (`features/client`_).


[2017-07-15]

- HTML4 profiles where initially intended for describing data schema for
  document metadata. With HTML5 their scope is extended to individual elements.

  TODO use ``sf-v0`` (listing it in wtwta.org htd-microfomats)
  same ID as current rjs app at
  ``/app/v0``, aliases: ``/_/``, ``/-/``,


[2017-02-15]

- jQuery Terminal is back. Needs some way to be usefull.

- Bootstrap (dropdown navbar) menu is initialized from JSON(s).
  Okay for links, but want something nicer for addon functionality.

- jQuery plugins, and jQuery UI Widgets for other UI components.


Wishlist
  Stuff. Take the term 'site' very liberal.
  See about someway to easily configure addons.

  - ECMAchine (LISP jQuery terminal)
    https://github.com/AlexNisnevich/ECMAchine
  - Socket.IO based in-browser (jQuery) terminal
    https://github.com/avalanche123/node-console

    Other ideas:

    - https://www.npmjs.com/package/node-web-repl
    - Has a bunch of the shell commands
      https://agnostic.housegordon.org/
    - some cool tools https://warlab.info/
    - user-friendly CLI tools even
      http://www.datacentred.co.uk/blog/introducing-openstack-browser-terminal/


Intro
-----
The easy way for Sitefile to get HTML content, is by relying on other projects
for document rendering. E.g. docutils or pandoc for reStructuredText, Mylyn
for various wiki formats, or another one of the many markdown, textile and other
document source formats.

This is also the least controlled and predictable way for Sitefile to setup a
generic and consistent user client.

Lets look at the options to bootstrap we have bootstrapping an interactive HTML
client.

Design
-------
Three modes to render content and client.
Then some thoughts on how to leverage r.js properly in addons.

.. sectnum::

Source rewite
_____________
Raw HTML Rewrite.

This option is available to the Sitefile output handling code and any non-secure
HTTP proxy. It may even be possible to add HTML elements to the stream, and
still have the client interpret them. Ie. as additional ``<script/>`` elements.

The current r0.0.7 Sitefile approach is to add elements before the ``</head>``
tag.

See ``ctx.rawhtml_*`` functions, provided by `Context Core prototype`_.


Envelope
________
This is a variant of HTML source rewite, except it also deals with situations
where the renderer produces only ``<body/>`` content.

Here, the Sitefile router handler wraps the body HTML content with the
appropiate ``<html>`` and includes the ``<head>``. Leaving the generation
of the title, meta, script and links up to the server-side route handler.

E.g. the `markdown`_ router needs this pattern.


client-side DOM manipulation
____________________________
here we miss the egg but then complete the circle of chickens and eggs,
but this only works for routers mentioned in 2. that can have (client)
scripted rendering.

This does enable to build a HTML+JS client, like app/v0 which can then
be used to navigate around for any resource wether HTML and with Nav or not.
This is an important feature, but for Sf core focus needs to stay on
essential tooling too, not just about pulling magic from the cloud.



Addons
______
Something better to add client style/script than Sitefile option lists.
A dev setup could build its assets, but other setups need dists.

Cant really decide on a builder. Which may be part of considerations.
Webpack, coffee-script, Babel etc. Thoughts on this go into features/build

During development, serving resources directly is most convenient.
But building involves resolving dependencies, packaging, new files, cached
files.

Packaging would improve testability, add isolation.

Invariably the packagers (webpack, require.js) tend to be a bit smartypants
and not always easily tamed. But the goal is the same: resolve dependencies,
and can we please handle js/css/fonts/... UI-parts transparently as a resource
too.


Progress
--------
app/v0 (`features/rjs`_) does at least part of the require-js fest.
But no fonts, css.

[2017-10-14] See ``app/v0-yaml`` for initial upgrade to client setup.


