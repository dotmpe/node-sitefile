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
  if params.link_stylesheet
    flags.push '--link-stylesheet'
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

  prm = _.defaultsDeep params,
    format: 'pseudoxml'
    docpath: 'index'
    link_stylesheet: false
    stylesheets: []
    scripts: []

  cmdflags = rst2html_flags prm

  if prm.format == 'source'
    sitefile.log "Du.source", prm.docpath
    out.type 'text/plain'
    out.write fs.readFileSync "#{prm.docpath}"
    out.end()

  else
    cmd = "rst2#{prm.format} #{cmdflags} '#{prm.docpath}'"
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

  # Return obj. w/ metadata & functions
  name: 'du'
  label: 'Docutils Publisher'
  usage: """
    du:**/*.rst
  """
  
  prereqs:
    test_for_du: test_for_du
    test_for_fe: test_for_fe
  tools:
    rst2html: rst2html

  # Generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->

      # FIXME: improve Context API:
      extra = (
        docpath: path.join(  ctx.cwd, rctx.res.path ),
        src: format: rctx.res.extname.substr 1
        dest: format: path.extname(rctx.res.ref)?.substr(1) or 'html'
      )
      rctx.prepare_from_obj extra
      rctx.seed extra


      ( req, res, next ) ->
        req.query = _.defaults req.query || {},
          format: rctx.dest.format,
          docpath: rctx.docpath

        try
          rst2html res, _.merge {}, rctx.route.options, req.query
        catch error
          console.log error
          res.type('text/plain')
          res.status(500)
          res.write("exec error: "+error)
          res.end()

