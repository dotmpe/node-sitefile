# Tasks

## Routers

TODO: map extensions. Ie default spec should be like makefile: path%.trgt: path%.src
FIXME: rst2html router context is broken.
TODO: map prefixes.

### File Formats

#### Documents
Literal formats.

##### Python Docutils (reStructuredText)

###### Compiled CSS for Docutils
SCSS or Stylus.

> public/media/style/default.css:/* TODO: want something like LESS or SASS to build from a common src/css base... can do? */
> ReadMe.rst:document possibilities emerge. :todo:`TODO:` Sitefile provides for a pre-styled CSS file

###### reStructuredText
src/dotmpe/sitefile/routers/du.coffee:XXX: get all dependencies somehow, and route them?
src/dotmpe/sitefile/routers/du.coffee:XXX: du.mpe compatible with fallback or?
> ReadMe.rst:  TODO: all docutils output formats (pxml, xml, latex, s5, html)


## Configuration

NOTE: in yaml, _1 or __1 will not work, YAML strips '_' so it turns into a std. route.
Not sure if this is particular to the library.


### Metadata $ref resolving (JSON path refs)
> src/dotmpe/context.coffee:    # XXX this starts top-down, but forgets context. may need to globalize
> src/dotmpe/context.coffee:        if value.$ref # XXX resolve absolute JSON ref

### Sitefile schema
> ReadMe.rst:- :todo:`TODO add YAML, JSON validators. jsonary perhaps.`
> src/dotmpe/sitefile/sitefile.coffee:  # TODO: validate Sitefile schema
> ReadMe.rst:TODO: load schema not just to validate Sitefile but to specify/generate/validate
> ReadMe.rst:  for Versions_ for values. XXX This could be replaced by a $schema key maybe.


## Sitefile internals
> src/dotmpe/sitefile/sitefile.coffee:    # XXX config per client
> src/dotmpe/sitefile/sitefile.coffee:    # TODO May want the same for regular routes.
> src/dotmpe/sitefile/sitefile.coffee:    # TODO Also need to refactor, and scan for defaults across dirs rootward
> src/dotmpe/sitefile/sitefile.coffee:            url = '/' + basename # FIXME route.replace('$name')
> src/dotmpe/sitefile/sitefile.coffee:            url = "/#{dirname}/#{basename}" # FIXME route.replace('$name')
> src/dotmpe/sitefile/sitefile.coffee:# XXX only reloads on src file or sitefile change
> src/dotmpe/sitefile/sitefile.coffee:# XXX does not reload routes, code+config only
> src/dotmpe/sitefile/sitefile.coffee:# TODO should reload sitefilerc, should reset/apply routes


## Misc
> ReadMe.rst:XXX: sitefilerc will be described later, if Sitefile schema (documentation) is set up.
> ReadMe.rst:XXX the sitefile config itself can go, be replaced by external
> ReadMe.rst:  TODO: see also sitefilerc
> ReadMe.rst:XXX specs contain as little embedded metadata as possible, focus is on
> ReadMe.rst:- ``redir``\ specify a redirect FIXME glob behaviour?
> ReadMe.rst:- module.export callback receives sitefile context, XXX should return::
> ReadMe.rst:- :todo:`maybe implement simple TODO app as a feature branch somday`


## Testing
> Makefile:# FIXME jasmine from grunt?


