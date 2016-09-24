###
Work in progress docutils router for sitefile.

XXX: get all dependencies somehow, and route them?
     (embedded references; links and includes)

XXX: du.mpe compatible with fallback or?

###
_ = require 'lodash'
path = require 'path'

librst2html = require './rst2html'


# Given sitefile-context, export metadata for du: handlers
module.exports = ( ctx={} ) ->

  rst2html = librst2html(ctx)
  if not rst2html
    return

  _.defaults ctx,
    # base-url / prefix for local routes
    base_url: 'dotmpe'

  name: 'du'
  label: 'Docutils Publisher'
  usage: """
    du:**/*.rst
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->
    _.defaults ctx, cwd: process.cwd(),
      dest: format: 'html'
      src: format: 'rst'

    docpath = path.join ctx.cwd, spec
    ( req, res, next ) ->
      req.query = _.defaults req.query || {},
        format: ctx.dest.format,
        docpath: docpath

      if ctx.sitefile.params and 'du' of ctx.sitefile.params
        params = ctx.resolve 'sitefile.params.du'
      else
        params = {}

      try
        rst2html.lib.rst2html res, _.merge {}, params, req.query
      catch error
        console.log error
        res.type('text/plain')
        res.status(500)
        res.write("exec error: "+error)
        res.end()


  route:
    base: ctx.base_url
    # local route handlers
#    du:
#      get: (req, res, next) ->

