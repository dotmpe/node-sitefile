###
Work in progress docutils router for sitefile.
###
_ = require 'lodash'
path = require 'path'
util = require 'util'
fs = require 'fs'
child_process = require 'child_process'

sitefile = require '../sitefile'
Router = require '../Router'


rst2html_flags = ( params ) ->

  flags = []

  # Note: link-stylsheets is only in effect if a list is given
  if params.stylesheets? and Array.isArray params.stylesheets
    if params.link_stylesheets
      flags.push '--link-stylesheet'
      sheets = _.filter(_.map(params.stylesheets, 'url')).join ','
      flags.push "--stylesheet '#{sheets}'"
    else
      sheets = _.filter(_.map(params.stylesheets, 'path')).join ','
      flags.push "--stylesheet-path '#{sheets}'"

  if params.flags? and !_.isEmpty params.flags
    flags = flags.concat params.flags

  flags.join ' '


test_for_du = ->
  try
    child_process.execSync "python -c 'import docutils'"
    return true
  catch error
    return

test_for_fe = ( name ) ->
  try
    child_process.execSync "which #{name}.py"
    return true
  catch error
    return


###
Take parameters
Async rst2html writes to out or throws exception
###
rst2html = ( out, ctx, params={} ) ->

  prm = _.defaultsDeep params,
    format: 'pseudoxml'
    docpath: 'index'
    link_stylesheets: false
    stylesheets: []
    scripts: []
    clients: []
    meta: [
      #  name: "application-name"
      #  content: "Sitefile/"+context.version
      #,
        name: "sitefile-router"
        content: "rsr2html"
    ]

  cmdflags = rst2html_flags prm

  if prm.format == 'source'
    sitefile.log "Du.source", prm.docpath
    out.type 'text/plain'
    out.write fs.readFileSync "#{prm.docpath}"
    out.end()

  else
    cmd = "rst2#{prm.format}.py #{cmdflags} '#{prm.docpath}'"
    sitefile.log "Du.rst2html", cmd

    child_process.exec cmd, maxBuffer: 1024*1024, (error, stdout, stderr) ->
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
        scripts = if 'urls' of prm.scripts and prm.scripts.urls then \
          prm.scripts.urls else prm.scripts
        # coffeelint: disable=ensure_comprehensions
        stdout = ctx.rawhtml_script(stdout, script) for script in scripts
        if prm.clients
          stdout = ctx.rawhtml_client(stdout, client) for client in prm.clients
        if prm.meta
          ctx.process_meta(prm.meta)
          stdout = ctx.rawhtml_meta(stdout, prm.meta)
        # coffeelint: enable=ensure_comprehensions
        out.write stdout

      else if prm.format == 'pseudoxml'
        out.type 'text/plain'
        out.write stdout
      out.end()



# Given sitefile-context, export du: router module
module.exports = ( ctx ) ->

  # Block until checked for Du, else return null; no handler
  if not test_for_du()
    sitefile.warn "No Docutils, returning null router"
    return

  # Return obj. w/ metadata & functions
  name: 'docutils'
  label: 'Docutils Publisher'
  usage: """
    docutils.rst2html:**/*.rst
  """

  prereqs:
    test_for_du: test_for_du
    test_for_fe: test_for_fe
  tools:
    rst2html: rst2html

  defaults:
    handler: 'rst2html'

  # Generators for Sitefile route handlers
  generate:
    rst2html: ( rctx ) ->
      ( req, res, next ) ->
        if rctx.res.rx?
          m = rctx.res.rx.exec req.originalUrl
          if rctx.route.spec
            rstpath = rctx.route.spec+m[1]+'.rst'
          else
            rstpath = m[1]+'.rst'
        else
          rstpath = if rctx.res.path then rctx.res.path else rctx.route.spec
        rstpath = Router.expand_path rstpath, ctx
        sitefile.log "SASS compile", rstpath

        # FIXME: improve Context API:
        extra = (
          docpath: rstpath # path.join(  ctx.cwd, rctx.res.path ),
          src: format: 'rst' #rctx.res.extname.substr 1
          dest: format: 'html'
          # FIXME path.extname(rctx.res.ref)?.substr(1) or 'html'
        )
        #rctx.prepare_from_obj extra
        #rctx.seed extra

        req.query = _.defaults req.query || {},
          format: extra.dest.format,
          docpath: extra.docpath

        st = fs.statSync(req.query.docpath)
        res.set 'Last-Modified', st.mtime.toUTCString()

        try
          rst2html res, ctx, _.merge {}, rctx.route.options, req.query
        catch error
          ctx.warn error
          res.type('text/plain')
          res.status(500)
          res.write("exec error: "+error)
          res.end()
