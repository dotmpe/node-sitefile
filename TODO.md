# Epic 1: serve a simple website
## Routers
- TODO: map extensions. Ie. default spec would be something like makefile: path%.trgt: path%.src
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
src/dotmpe/sitefile/routers/du.coffee:XXX: get all dependencies somehow, and route them?
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
- NOTE: in yaml, _1 or __1 will not work, YAML strips '_' so it turns into a std. route.
  Not sure if this is particular to the library.

### Metadata $ref resolving (JSON path refs)
- src/dotmpe/context.coffee:    # XXX this starts top-down, but forgets context. may need to globalize
- src/dotmpe/context.coffee:        if value.$ref # XXX resolve absolute JSON ref

### Sitefile schema
- ReadMe.rst:- :todo:`TODO add YAML, JSON validators. jsonary perhaps.`
- src/dotmpe/sitefile/sitefile.coffee:  # TODO: validate Sitefile schema
- ReadMe.rst:TODO: load schema not just to validate Sitefile but to specify/generate/validate
- ReadMe.rst:  for Versions_ for values. XXX This could be replaced by a $schema key maybe.

### On the fly reload
- src/dotmpe/sitefile/sitefile.coffee:# XXX only reloads on src file or sitefile change
- src/dotmpe/sitefile/sitefile.coffee:# XXX does not reload routes, code+config only
- src/dotmpe/sitefile/sitefile.coffee:# TODO should reload sitefilerc, should reset/apply routes

## Sitefile internals
- src/dotmpe/sitefile/sitefile.coffee:    # XXX config per client
- src/dotmpe/sitefile/sitefile.coffee:    # TODO May want the same for regular routes.
- src/dotmpe/sitefile/sitefile.coffee:    # TODO Also need to refactor, and scan for defaults across dirs rootward
- src/dotmpe/sitefile/sitefile.coffee:            url = '/' + basename # FIXME route.replace('$name')
- src/dotmpe/sitefile/sitefile.coffee:            url = "/#{dirname}/#{basename}" # FIXME route.replace('$name')
 
- ReadMe.rst:XXX: sitefilerc will be described later, if Sitefile schema (documentation) is set up.
- ReadMe.rst:XXX the sitefile config itself can go, be replaced by external
- ReadMe.rst:  TODO: see also sitefilerc

## Misc
- ReadMe.rst:XXX specs contain as little embedded metadata as possible, focus is on
- ReadMe.rst:- ``redir``\ specify a redirect FIXME glob behaviour?
- ReadMe.rst:- module.export callback receives sitefile context, XXX should return::

# Project tooling
- PLAN: make some guards to determine version increment, maybe some gherkin specs.
- https://codeclimate.com/ "Automated code review for Ruby, JS, and PHP."
- :todo:`add express functions again:`
    | "connect-flash": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

## Testing
- Makefile:# FIXME jasmine from grunt?


