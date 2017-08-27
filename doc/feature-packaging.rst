Packaging
=========
.. include:: .defaults.rst

:created: 2017-08-25
:updated: 2017-08-26

..

  The high-level, birds eye overview on packaging has its own document__.
  But as for the details on the build system and project deployment, the only
  details are the source and some mentions spread around.

  Not sure yet about the Sitefile dev & test setup, but may integrate part of it
  with core Sitefile. Its about prototyping the very thing it is written in
  after all. Until a 1.0 or 0.1.0 release its all kind of mix of development and
  vapourware.

  But see other places that concern packing:

  - `features/dhtml`_ Addons
  - `features/documentation`_
  - `features/rjs`_


.. __: feature-packaging.rst


The main dev. document lists features categorized to the basic Sitefile
functionality. For the third epic, re-usable packages are indicated, and for
this some project specific development points are listed. But given all the
dependencies a form of suite-based installables with limited, application
specific dependencies may ease deployment and security considerations a bit.

For the dirty parts on current build and packing see the other specific
development targets under `feature 3`__.

Some ideas for future extension and topical grouping.


.. __: dev.rst#feature-3

----

Development
  Bookmarklets. User-defined tools to use in navigation, editing. Maybe
  some kind of bookmarklet cdn to ship, update, generate, version bookmarklets?

  Issues, tasks. Refer, update, amend. Create and close.
  Embedded tasks.

  Sketchbooks, collections of editable, personal resources.
  Ie. see also wiki and other suites.


- diagramming, dashboards, log viewers, other interactive apps defined in local
  "sketchbooks". Akin to Processing, Arduino, but geared towards Web content.
  Ie. to prototype a JS, or quickly get some templated boilerplate HTML using
  Pug. Or CSS with SASS/SCSS/Stylus/LESS et al.

- Other web-related files: browse bookmarks, references. Taking notes from
  online content easily is a big use-case.

- work with metadata, schemas, use jsonary_ or json-editor. Go from YAML to JSON
  to some programming markup and back.

  .. note::

     Trying to give all the ideas a somewhat bounded topic in the suites below.

     For the base Development suite not so much interested in ie. IDE or
     media other than text initially except for the basic support.
     Because of the diversity, first trying cut at the RESTfull resource vs.
     files or data, and the microversioning issues.

  IDE experience, layer on NPM, Bower et al.
  CommonJS modules. Projects of var. type, with Makefile, Gruntfile.
  And don't forget Excuberant CTags.

Wiki
  Client centric reader/author. Edit inline, or side-by-side. Interact with
  versions and backups.
  Portable. Possibly "traveling" content too.

CDN
  Libraries, versions and prerequisites. Possibly build or resolve caches,
  adaption, conversion, transpilation, add envelopes or packaging.

Media
  Forms, Genres, Styles. Streaming. Metadata.

  Mediafile viewer. 3D meshes using webGL.
  Resource carroussel, slideshows.
  Image books, ie. Pinterest.
  Or quotes. Lyrics, trivia.

Engineering
  Component design, specification, graphing, simulation.

Publishing, Typesetting, Book
  Readability. Structures, sequences, pagination. Hierarchies.
  Cross-Indexes, references. Sections. Appendices. Concordances. Etc. etc.
  Copy/Paste layouting. Edit Decision Lists.
  Citations, transclusion.
  Enfiladic hypertext, non-conventional interaction modes.

Research
  Learn by collection, aggregation. Hypomnemata.
  Manage corpusses, docuverses, web-to-resource bridges.

Site prototype builder
  Outliner.
  Literate Programming.
  Dynamic sitefiles.

Other expert systems
  Math, Statistics. Data sources. Simulation. Rule systems. Big-Data.
  Stock market. Crowds. Reasoning, trust, knowledge domains. Machine learning.
  Domation, IoT.

Support, control, monitoring for environment, infra or control structure.
NOC-style non-RTOS async distributed UI.
Collaboration, mesh networks, P2P, web sockets, pub/sub, protocol bridges.

undsofort..


.. include:: .defaults.rst
