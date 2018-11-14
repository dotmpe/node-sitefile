_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'
Router = require '../Router'


# Given sitefile-context, export metadata for markdown: handler
module.exports = ( ctx={} ) ->

  try
    md = require( 'markdown' ).markdown
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err

  template = Router.expand_path 'sitefile-client:view.pug', ctx

  name: 'markdown'
  aliases: 'markdown' # XXX: cannot use alias while only req. routers are loaded
  # Iow. some config/install process or action needs to set the explicit
  # alias-router map per instance.
  label: 'Markdown HTML publisher'
  usage: """
    markdown:**/*.md
  """

  defaults:
    global:
      default:
        options:
          pug:
            'export-context': 'merge.context'
            compile:
              pretty: false
              debug: false
              compileDebug: false
              globals: []
              filters: []
            merge:
              format: 'html'
              links: []
              scripts: []
              stylesheets: []
              clients: []


  generate:

    default: ( rctx ) ->
      pug = ctx._routers.get 'pug'
      # FIXME: cleanup schema checking to somewhere..
      if rctx.route.options.compile or rctx.route.options.merge
        ctx.warn "Sitefile.options.global", \
          "markdown should not have compile/merge. Use 'pug' sub-options."
      if not rctx.route.options.pug
        ctx.warn "Sitefile.options.global", \
          "No markdown.pug global options in Sitefile, used for markdown envelope"
        # XXX: should provide Pug compile/merge options or maybe use pug router
        # global settings...

      ( req, res ) ->
        sitefile.log 'Markdown default html publish', rctx.res.path

        data = fs.readFileSync rctx.res.path
        doc = md.toHTML data.toString()
        pugOpts = _.defaultsDeep rctx.route.options.pug, {
          tpl: template
          merge:
            ref: rctx.res.ref
            html:
              main: ''
              document: doc
              footer: ''
            context: ctx
        }

        res.type 'html'
        res.write pug.render pugOpts, rctx
        res.end()


    raw: ( rctx ) ->
      ( req, res ) ->
        sitefile.log 'Markdown raw html publish', rctx.res.path

        data = fs.readFileSync rctx.res.path
        doc = md.toHTML data.toString()
        res.type 'html'
        res.write doc
        res.end()
