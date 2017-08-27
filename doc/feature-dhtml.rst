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
  Maybe interact with the shell on the host.
  Certainly see about someway to easily configure addons.

  - ECMAchine (LISP jQuery terminal)
    https://github.com/AlexNisnevich/ECMAchine
  - Socket.IO based in-browser (jQuery) terminal
    https://github.com/avalanche123/node-console

    - If that does not work well maybe
      https://www.npmjs.com/package/node-web-repl

    - Has a bunch of the shell commands
      https://agnostic.housegordon.org/
    - some cool tools https://warlab.info/
    - user-friendly CLI tools even
      http://www.datacentred.co.uk/blog/introducing-openstack-browser-terminal/


Design
-------

Addons
  Something better to add client style/script than Sitefile option lists.
  A dev setup could build its assets, but other setups need dists.

  Cant really decide on a builder. Which may be part of considerations.
  Webpack, coffee-script, Babel etc.

  During development, serving resources directly is most convenient.
  But building involves resolving dependencies, packaging, new files, cached
  files.

  Packaging would improve testability, add isolation.

  Invariably the packagers (webpack, require.js) tend to be a bit smartypants
  and not always easily tamed. But the goal is the same: resolve dependencies,
  and can we please handle js/css/fonts/... UI-parts transparently as a resource
  too.

  app/v0 (`features/rjs`_) does at least part of the require-js fest.
  But no fonts, css.

