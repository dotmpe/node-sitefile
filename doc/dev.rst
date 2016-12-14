
.. include:: .defaults.rst


Main Features
--------------
These are features in development for the v0.1/v0.0.1 roadmap.

1. hypertext representation for file-based content.

   1. Text markup languages (md, rst, text-feature-docs__)
   2. Server side templates (pug)
   3. Scripts (js, coffee, requirejs)
   4. Stylesheets (sass, less, styl)
   5. Diagrams (gv, plantuml)
   6. Data (bookshelf-api, db-feature-docs__)
   7. Resources (http)
   8. Services (pm2)

2. work in progres: hypertext protocol support, abstract resources.

   1. HTTP Redirect
   2. Static resources
   3. Planned: variant resources
   4. Work in progress: proxy resources

3. work in progress: re-usable, and distributed packages of routes and
   resources.

   1. YAML and JSON based setup.
      Look at alternatively to operate from argv/env iso. local Sitefile
   2. work-in-progress: user-defined extensions, extendable resources/routers
      (route-feature-docs__)
   3. packages (JS/CSS/media), cdn config? (require-js-feature-docs__)

4. work in progress: a default or 'base' client,
   with decent support for all routes (html5-client-feature-docs__)



.. __: `Text Markup Feature`_
.. __: `Router Feature`_
.. __: `DB Feature`_
.. __: `RequireJS Feature`_
.. __: `HTML5 Client Feature`_


- `Text Markup Feature`_
- `Router Feature`_
- `HTML5 Client Feature`_
- `DB Feature`_

Other development features:

- `Testing Feature`_
- `Documentation Feature`_



Documentation
-------------
The Main documents are and will be reStructuredText. But for more flexibility
the administration of several other documents is for now at once done in the
TODO_ document. Some integrate them here later.
Sections:

- Hacking
- Design
- Roadmap
- Tasks and Bugs
- Project Tooling

* `Manual`_ initial sketchbook on usage.



Ideas
------

There are many possibly useful directions:

- transliterature browser, research tooling
- embedded issue browser/editor.
- a local Wiki, or notebook with in-browser editing. And what about tiddlywiki?
  Portabel, traveling content.

- viewer for media files
- 3D meshes using webGL
- diagramming, dashboards, log viewers, other interactive apps defined in local
  "sketchbooks". Akin to Processing, Arduino, but geared towards Web content.
  Ie. to prototype a JS, or quickly get some templated boilerplate HTML using
  Pug. Or CSS with SASS/SCSS/Stylus/LESS et al.

- Other web-related files: browse bookmarks, references. Taking notes from
  online content easily is a big use-case.

- Also bookmarklets. User-defined tools to use in navigation, editing. Maybe
  some kind of bookmarklet cdn to ship, update, generate, version bookmarklets?

- An simple URL carroussel/slideshow app? An image book, like pinterest.
  Or a quote book. Lyrics or music trivia collection.

- Interact with JSON data, API's.

- work with metadata, schemas, use jsonary_ or json-editor. Go from YAML to JSON
  to some programming markup and back.

- Provide an in-browser IDE experience, support NPM, Bower or other packages.
  CommonJS modules. Projects with Makefile, Gruntfile. Is excuberant CTags too
  far back?





Branch docs
------------
.. include:: scm-branches.rst



