_ = require 'lodash'
fs = require 'fs'
path = require 'path'
child_process = require 'child_process'
sitefile = require '../sitefile'


rst2html_flags = ( params ) ->

  flags = []
  if params.stylesheets? and !_.isEmpty params.stylesheets
    sheets = _.values(params.stylesheets).join ','
    flags.push "--stylesheet-path '#{sheets}'"
  if params.flags? and !_.isEmpty params.flags
    flags = flags.concat params.flags
  flags.join ' '


test_for_rst2html = ->
  child_process.exec "which rst2html.py", ( err, stdo, stde ) ->


add_script = ( rawhtml, javascript_url ) ->

  sitefile.log "rst2html:addscript", javascript_url
  script_tag = '<script type="text/javascript" src="'+javascript_url+'" ></script>'
  rawhtml.replace '</head>', script_tag+' </head>'


###
Take parameters
Async rst2html writes to out or throws exception
###
rst2html = ( out, params={} ) ->

  prm = _.defaults params,
    format: 'pseudoxml'
    docpath: 'index'
    link_stylesheet: false
    stylesheets: []
    scripts: []

  cmdflags = rst2html_flags prm

  cmd = "rst2#{prm.format} #{cmdflags} '#{prm.docpath}'"

  sitefile.log "Du", cmd

  if prm.format == 'source'
    out.type 'text'
    out.write fs.readFileSync "#{prm.docpath}"
    out.end()

  else

    child_process.exec cmd, (error, stdout, stderr) ->
      if error
        out.type 'text/plain'
        out.status 500
        out.write error.toString()
        #throw error
      else if prm.format == 'xml'
        out.type 'xml'
        out.write stdout
      else if prm.format == 'html'
        out.type 'html'
        # FIXME: rst2html: remove hardcoded javascript
        if not prm.scripts
          prm.scripts = [ '/build/script/default.js' ]
        stdout = add_script(stdout, script) for script in prm.scripts
        out.write stdout
      else if prm.format == 'pseudoxml'
        out.type 'text/plain'
        out.write stdout
      out.end()


# Given sitefile-context, export metadata for du: handlers
module.exports = ( ctx={} ) ->

  if not test_for_rst2html()
    return

  _.defaults ctx,

    # base-url / prefix for local routes
    base_url: null

  name: 'rst2html'
  label: 'Docutils rSt to HTML publisher'
  lib:
    rst2html: rst2html

  generate: ( rsctx ) ->

    docpath = path.join ctx.cwd, rsctx.path

    ( req, res, next ) ->

      # XXX: process.stdout.write "rst2html "+ docpath+ " handler call "

      req.query = _.defaults req.query || {},
        format: 'html'
        docpath: docpath

      if ctx.sitefile.params and 'rst2html' of ctx.sitefile.params
        params = ctx.resolve 'sitefile.params.rst2html'
      else
        params = {}

      #if ctx.sitefile.defs and 'stylesheets' of ctx.sitefile.defs
      #  params.stylesheets = ( params.stylesheets || [] ).concat ctx.sitefile.defs.stylesheets

      #if ctx.sitefile.defs and 'scripts' of ctx.sitefile.defs
      #  params.scripts = ( params.scripts || [] ).concat ctx..defs.scripts

      try
        rst2html res, _.merge {}, params, req.query
      catch error
        console.trace error
        console.log error.stack
        res.type 'text/plain'
        res.status 500
        res.write "exec error: #{error}"
        res.end()

  route:
    base: ctx.base_url
    rst2html:
      get: (req, res, next) ->

        req.query = _.defaults res.query || {}, format: 'xml'

        try
          rst2html res, _.merge {}, ctx.sitefile.specs.rst2html, req.query
        catch error
          console.trace error
          lib.warn error.stack
          res.type 'text/plain'
          res.status 500
          res.write "exec error: #{error}"
        res.end()

