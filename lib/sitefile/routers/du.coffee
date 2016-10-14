###
Work in progress docutils router for sitefile.

XXX: get all dependencies somehow, and route them?
     (embedded references; links and includes)

XXX: du.mpe compatible with fallback or?

###
_ = require 'lodash'
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


add_script = ( rawhtml, javascript_url ) ->

  sitefile.log "rst2html:addscript", javascript_url
  script_tag = '<script type="text/javascript" src="'+\
      javascript_url+'" ></script>'
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
    # FIXME: rst2html: remove hardcoded javascript
    scripts: [ '/build/script/default.js' ]

  cmdflags = rst2html_flags prm

  cmd = "rst2#{prm.format} #{cmdflags} '#{prm.docpath}'"
  sitefile.log "Du", cmd

  if prm.format == 'source'
    out.type 'text/plain'
    out.write fs.readFileSync "#{prm.docpath}"
    out.end()

  else
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
        stdout = add_script(stdout, script) for script in prm.scripts
        out.write stdout

      else if prm.format == 'pseudoxml'
        out.type 'text/plain'
        out.write stdout
      out.end()



# Given sitefile-context, export du: router module
module.exports = ( ctx ) ->

  # Block until checked for Du, else return null; no handler
  if not test_for_du()
    sitefile.warn "No Docutils"
    return
  
  _.defaults ctx,
    # base-url / prefix for local routes
    base_url: 'dotmpe'

  # Return obj. w/ metadata & functions
  name: 'du'
  label: 'Docutils Publisher'
  usage: """
    du:**/*.rst
  """
  route:
    base: ctx.base_url
  
  prereqs:
    test_for_du: test_for_du
    test_for_fe: test_for_fe
  tools:
    rst2html: rst2html

  # Generators for Sitefile route handlers
  generate: ( rsctx ) ->

    # FIXME: improve Context API:
    extra = (
      docpath: path.join(  ctx.cwd, rsctx.path ),
      src: format: rsctx.extname.substr 1
      dest: format: path.extname(rsctx.ref)?.substr(1) or 'html'
    )
    rsctx.prepare_properties extra
    rsctx.seed extra

    ( req, res, next ) ->
      req.query = _.defaults req.query || {},
        format: rsctx.dest.format,
        docpath: rsctx.docpath

      # TODO: move one or two scopes up, but implement router relouding first;
      # keeping this here allows for params to be refreshed.
      params = if ctx.sitefile.params and 'du' of ctx.sitefile.params \
        then ctx.resolve 'sitefile.params.du' else {}

      try
        rst2html res, _.merge {}, params, req.query
      catch error
        console.log error
        res.type('text/plain')
        res.status(500)
        res.write("exec error: "+error)
        res.end()

