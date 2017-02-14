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


  name: 'markdown'
  label: 'Markdown HTML publisher'
  usage: """
    markdown:**/*.md
  """

  defaults:
    global:
      default:
        options:
          pug:
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
      ( req, res ) ->
        sitefile.log 'Markdown default html publish', rctx.res.path
        data = fs.readFileSync rctx.res.path
        doc = md.toHTML data.toString()
        pugOpts = _.defaultsDeep rctx.route.options.pug, {
          tpl: Router.expand_path 'sitefile-client:view.pug', ctx
          merge:
            ref: rctx.res.ref
            html:
              main: ''
              document: doc
              footer: ''
        }
        res.type 'html'
        res.write pug.compile pugOpts
        res.end()


    raw: ( rctx ) ->
      ( req, res ) ->
        sitefile.log 'Markdown raw html publish', rctx.res.path

        data = fs.readFileSync rctx.res.path
        doc = md.toHTML data.toString()
        res.type 'html'
        res.write doc
        res.end()


