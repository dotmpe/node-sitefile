
# Hacking
Some guidelines:
- Development on `dev` branch, notes in doc/dev/<version>.rst. 
- (Semi-)Finished features in ChangeLog, unreleased versions are enclosed in 
  round brackets.
- Current *Tasks and bugs* in section below.
- Dedicated features branches for specific tasks. Maybe dev release branches
  for parallel dev/maintenance.

Checklist for new features
- Feature is placed as an addition to one main feature or sub-feature.

  Mentioned in 

  First during the development in dev milestone document, and after intial 
  release also in the main feature list and as items of changelog entries.

- Finished feature is described 



Design points:

No distinction between url paths or local file paths.
Prefer for local file based defnitions for resources or API.

Initial router API consists of the `generate` function. Perhaps move to a
schema for the attributes. Maybe combine with Sitefile schema.

Possibly for more types of use; standalone. No Sitefile.{json,yaml}?

In particular control the envelope and delivery of content. Manage style,
script and maybe (later) links, metadata, and then later profiles, schema..

Ie. locate, dereference, negotiate, resolve content, etc. and serve to a
suitable client e.g. browser.


Next:

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





# Roadmap
Stage is in initial development. 
Upcoming 
First versions upcoming:

## 0.1.0
* Milestone 1: serve a simple website of (derived) HTML, CSS, JS content
    1. Text markup languages (md, rst)
    2. Server side templates (pug)
    3. Scripts (js, coffee, requirejs)
    4. Stylesheets: SASS/SCSS, Stylus, Less
    5. Diagrams: Graphviz, PlantUML, ditaa
    6. Data: Knex (SQL ORM) and Bookshelf API (with Backbone-style REST i'face)
    7. Resources: http, cdn
    8. Services: pm2
    * Convert and edit metadata: json, yaml
    * Edit other files
    * SCM: git
* Milestone 2: support variant resources, and data and action URL endpoints
    * Document viewer and editor.
    * Router and resource extensions; local user-defined or packaged suites.

Maybe 2017-ish.

## 1.0.0
- Milestone 3: package extension routers and resource bundles
    - Lightweight Sitefile core.
    - Extension packs, suites; maybe some verticals, e.g. a GIT wiki.

## Dev
Next release 0.0.5, dec 2016/jan 2017.
Current: documentation and updating test setup in preparation to stabalize.
Next: Work on 0.1 features.

### (0.0.x)
Want most features of 0.1.0 soonish.

- Documented features, tests and reporting on feature functionality.

### (0.0.6)
- Try to stabalize context schema. Maybe for 0.1?
  So routers can stabalize too.
  And also, nodelib, point at some things that it needs for 0.1.


# Tasks and Bugs

## Routers
- TODO:route: map extensions. Ie. default spec would be something like makefile: path%.trgt: path%.src
- TODO: map prefixes.
- TODO: finalize 0.1.0 specifications and define BWC components/interfaces.
- FIXME: rst2html router context is broken.

### Documents
- TODO: manage view: style and scripts. Automatic reload browser on change.
  See also 'App platform' task. Solve some other router and configuration issues 
  first.
- TODO: browser reset styles, some simple local Du/rSt styles in e.g. Stylus
- http://asciidoctor.org/
  AsciiDoc processor in Ruby? Maybe add a section of plain text markup formats.

#### Python Docutils (reStructuredText)

- TODO: Compiled CSS for Docutils. SCSS or Stylus.
- public/media/style/default.css:/* TODO: want something like LESS or SASS to build from a common src/css base... can do? */
- ReadMe.rst:document possibilities emerge. :todo:`TODO:` Sitefile provides for a pre-styled CSS file
- TODO: export some tokens (terms, titles, topics) for autolinking
- src/dotmpe/sitefile/routers/du.coffee:XXX: get all dependencies somehow, and route them?
- Also: export docinfo or other field maps, maybe refs, etc.
- src/dotmpe/sitefile/routers/du.coffee:XXX: du.mpe compatible with fallback or?
- ReadMe.rst:  TODO: all docutils output formats (pxml, xml, latex, s5, html)

#### Markdown
- TODO: add HTML envelope

## App platform
- Fix ext-mapping in routing, and start re-using resources; build one on
  another, extend.
- PLAN: Provide for an initial customizable app stack with RequireJS, 
  Coffee-Script, SASS/SCSS. 
  Think about example/demo repo and keeping files low, focus on 
  testing and documentation.
- TODO: live customization of views.
- TODO: components, should want to deal with optional deps. iso. req'ments.
- FIXME: Consolidate reader.rst into package/stack.
- XXX: maybe implement simple TODO app as a feature branch somday
- TODO: site builds, packaging

## Configuration
- NOTE: in yaml, `_1` or `__1` will not work, YAML strips `_` so it turns into a std. route.
  Not sure if this is particular to the library.

### Metadata $ref resolving (JSON path refs)
- src/dotmpe/context.coffee:    # XXX this starts top-down, but forgets context. may need to globalize
- src/dotmpe/context.coffee:        if value.$ref # XXX resolve absolute JSON ref

### Sitefile schema
- TODO YAML, JSON validation. jsonary perhaps. $schema
- src/dotmpe/sitefile/sitefile.coffee:  # TODO: validate Sitefile schema
- ReadMe.rst:TODO: load schema not just to validate Sitefile but to specify/generate/validate

### On the fly reload
- src/dotmpe/sitefile/sitefile.coffee:# XXX only reloads on src file or sitefile change
- src/dotmpe/sitefile/sitefile.coffee:# XXX does not reload routes, code+config only
- src/dotmpe/sitefile/sitefile.coffee:# TODO should reload sitefilerc, should reset/apply routes

## Sitefile internals
- src/dotmpe/sitefile/sitefile.coffee:    # TODO Also need to refactor, and scan for defaults across dirs rootward
 
- ReadMe.rst:XXX: sitefilerc will be described later, if Sitefile schema (documentation) is set up.
- ReadMe.rst:XXX the sitefile config itself can go, be replaced by external
- ReadMe.rst:  TODO: see also sitefilerc

## Misc
- ReadMe.rst:XXX specs contain as little embedded metadata as possible, focus is on
- ReadMe.rst:- ``redir``\ specify a redirect FIXME glob behaviour?
- ReadMe.rst:- module.export callback receives sitefile context, XXX should return::


# Project tooling
- PLAN: make some guards to determine version increment, maybe some gherkin specs.
  TODO: cleanup and standardize to ttxt?

- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- TODO: have a look again at Express middleware

    "connect-flash": "latest",
    "method-override": "^2.3.2",
    "node-uuid": "^1.4.3",
    "notifier": "latest"

## Testing
- Makefile:# FIXME jasmine from grunt?



.. [#] `nodejs-socketio-seed <http://github.com/dotmpe/nodejs-express-socketio-seed>`_

