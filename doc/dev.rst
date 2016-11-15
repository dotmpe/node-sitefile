
.. include:: .defaults.rst

.. contents::


Epics
------
Current:

- Add hypertext capability to file-based content.

  In particular control the envelope and delivery of content. Manage style,
  script and maybe (later) links, metadata, and then later profiles, schema..

  Ie. locate, dereference, negotiate, resolve content, etc. and serve to a
  suitable client e.g. browser.

There are many possibly useful directions:

- transliterature browser, research tooling
- embedded issue browser/editor.
- a local Wiki, or notebook with in-browser editing. And what about tiddlywiki?
  Portabel, traveling content.

- viewer for media files
- 3D meshes using webGL

- other web-related files: browse bookmarks, references. An simple URL carroussel/slideshow app?
- interact with JSON data, maybe API's, use jsonary_ or json-editor

- provide an in-browser IDE experience, possibly enabling Makefiles and other
  buildformats. Excuberant CTags.

Next:

- Start to index some things and serve metadata.
  Ie. link headers.

- Move to a concept of a standard file-type handler registry, posibly some
  magic. Use Sitefile to index (only) those resources that are linked together,
  likely introduce domain or site attribute (ie. specify a 'docuverse', or 'linking space' within which the hyperlinks/references can act, and which in other ways determines presentation, as apposed to the content which is in principle a set of plain text human readable and processable files).

- Better HTTP conformance.

Think about:

- Want to keep it lean, and simple. Sitefile currently (<0.0.5-dev) is under 350 LoC. But:

- need to integrate concept of content-type (ie. representation vs. resource) to
  deal with parametrizing the publisher (routers). Currently the routers are purposely very naively implemented to focus on a generic, flexible Sitefile schema.

- Setup some transclusion micro-protocol (over HTML+XmlHttpRequest) for dynamic branching, and mix/browser content client-side using hash-navigation, building up a client-side app essentially.

  Again, keep going for dynamic, branching literal content and build on this.
  Avoid creating rolodexes and card boxes.



Branch docs
------------
.. include:: scm-branches.rst


Misc.
------

- PLAN: make some guards to determine version increment, maybe some gherkin specs.
- TODO: components, should want to deal with optional deps. iso. req'ments.
- TODO: browser reset styles, some simple local Du/rSt styles in e.g. Stylus
- TODO: maybe implement simple TODO app as a feature branch someday.

- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- :todo:`add express functions again:`
    | "connect-flash": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

- http://asciidoctor.org/
  AsciiDoc processor in Ruby? Maybe add a section of plain text markup formats.
- TODO: site builds, packaging

Data
  See also x-loopback. Maybe keep al backend/auth/data-proxy-middleware out
  of Sitefile. Express is better for other middleware.
  Maybe some simple
  standardized data API, ie. the odata for the TODO app.

  But need bigger toolkit too:

  - TODO: YAML, JSON validation. Schema viewing. tv4, jsonary.
  - TODO: JSON editor, backends, schema and hyper-schema
  - Book `Understanding JSON Schema`_
  - Article `Elegant APIs with JSON Schema`_

See also ToDo_ document. TODO: cleanup and standardize to ttxt.


