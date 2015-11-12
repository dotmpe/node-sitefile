_ = require 'lodash'
fs = require 'fs'
path = require 'path'
child_process = require 'child_process'


rst2html_flags = ( params ) ->

  flags = []
  if params.stylesheets? and !_.isEmpty params.stylesheets
    sheets = _.values(params.stylesheets).join ','
    flags.push "--stylesheet-path '#{sheets}'"
  flags.join ' '


test_for_rst2html = ->
  child_process.exec "which rst2html.py", ( err, stdo, stde ) ->


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

  cmdflags = rst2html_flags prm

  cmd = "rst2#{prm.format}.py #{cmdflags} '#{prm.docpath}.rst'"

  if prm.format == 'source'
    out.type 'text'
    out.write fs.readFileSync "#{prm.docpath}.rst"
    out.end()

  else

    child_process.exec cmd, (error, stdout, stderr) ->
      if error
        throw error
      else if prm.format == 'xml'
        out.type 'xml'
        out.write stdout
      else if prm.format == 'html'
        out.type 'html'
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
  generate: ( spec, ctx ) ->
    docpath = path.join ctx.cwd, spec
    ( req, res, next ) ->
      req.query = _.defaults req.query || {},
        format: 'html',
        docpath: docpath

      # FIXME ctx.resolve 'sitefile.params.du'
      if ctx.sitefile.params and 'du' of ctx.sitefile.params
        params = ctx.sitefile.params.du
      else
        params = {}

      if ctx.sitefile.defs and 'stylesheets' of ctx.sitefile.defs
        params.stylesheets = ( params.stylesheets || [] ).concat ctx.sitefile.defs.stylesheets

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
          console.log error.stack
          res.type 'text/plain'
          res.status 500
          res.write "exec error: #{error}"
        res.end()

