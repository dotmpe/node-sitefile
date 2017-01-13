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
    if params.link_stylesheets
      expand_url_ = ( u ) -> sitefile.expand_url u, base=params.base
      flags.push '--link-stylesheet'
      urls = _.filter(_.map(params.stylesheets, 'url'))
      sheets = _.map(urls, expand_url_).join ','
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


add_script = ( rawhtml, javascript_url, base='/' ) ->
  url = sitefile.expand_url javascript_url, base
  sitefile.log "du:rst2html:addscript", url
  script_tag = '<script type="text/javascript" src="'+url+'" ></script>'
  rawhtml.replace '</head>', script_tag+' </head>'


###
Take parameters
Async rst2html writes to out or throws exception
###
rst2html = ( out, params={} ) ->

  prm = _.defaultsDeep params,
    format: 'pseudoxml'
    docpath: 'index'
    link_stylesheets: false
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
        if prm.scripts
          for script in prm.scripts
            if 'object' is typeof script
              stdout = add_script stdout, script.url, prm.base
            else
              stdout = add_script stdout, script, prm.base
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
    du.rst2html:**/*.rst
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
          base: ctx.base()

        try
          rst2html res, _.merge {}, rctx.route.options, req.query
        catch error
          console.log error
          res.type('text/plain')
          res.status(500)
          res.write("exec error: "+error)
          res.end()

