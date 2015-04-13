_ = require 'lodash'
fs = require 'fs'
path = require 'path'
child_process = require 'child_process'



rst2html_flags = ( params ) ->

  flags = []
  if params.stylesheets? and !_.isEmpty params.stylesheets
    sheets = params.stylesheets.join ','
    flags.push "--stylesheet-path '#{sheets}'"
  flags.join ' '


test_for_rst2html = ->
  child_process.exec "which rst2html.py", ( err, stdo, stde ) ->

defaults =
  rst2html:
    # XXX see du: router
    format: 'pseudoxml'
    docpath: 'index'
    # html params:
    link_stylesheet: false
    stylesheets: []

###
Take parameters
Async rst2html writes to out or throws exception
###
rst2html = ( out, params={} ) ->

  prm = _.defaults params, defaults.rst2html
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
    base_url: null

  name: 'rst2html'
  label: 'Docutils rSt to HTML publisher'
  defaults:
    defaults
  lib:
    rst2html: rst2html

  generate: ( spec, ctx ) ->
    docpath = path.join ctx.cwd, spec
    ( req, res, next ) ->
      req.query = _.defaults req.query || {},
        format: 'html'
        docpath: docpath
      try
        params = ctx.resolve 'sitefile.params.rst2html'
        rst2html res, _.merge {}, params, req.query
      catch error
        console.log error
        res.type 'text/plain'
        res.status 500
        res.write "exec error: #{error}"
        res.end()

  route:
    base: ctx.base_url
    browser:
      route:
        rst: ( req, res, next ) ->

# XXX New style routes (
###
  route:
  - handler: ->
    all: 'src/*': 'prism:'
###

