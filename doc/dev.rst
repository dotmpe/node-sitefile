
.. include:: .defaults.rst


Main Features
--------------
1. hypertext representation for file-based content.

   1. Text markup languages (feature-docs__, md, rst)
   2. Server side templates (pug)
   3. Scripts (js, coffee, requirejs)
   4. Stylesheets (sass, less, styl)
   5. Diagrams (gv, plantuml)
   6. Data (db-feature-docs__, bookshelf-api)
   7. Resources (http)
   8. Services (pm2)

2. work in progres: hypertext protocol support, abstract resources.

   1. HTTP Redirect
   2. Static resources
   3. Planned: variant resources
   4. Work in progress: proxy resources

3. work in progress: re-usable, and distributed packages of routes and
   resources.

   1. YAML and JSON based setup. (route-feature-docs__)
      Look at alternatively to operate from argv/env iso. local Sitefile
   2. work-in-progress: user-defined extensions, extendable resources/routers
   3. packages (JS/CSS/media), cdn config? (require-js-feature-docs__)


These are the main milestones for the development.


.. __: `Text Markup Feature`__
.. __: `DB Feature`__
.. __: `Router Feature`__
.. __: `RequireJS Feature`__



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



