_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'
Router = require '../Router'


# Given sitefile-context, export metadata for markdown-it: handler
module.exports = ( ctx={} ) ->

  try
    markdown_it = require( 'markdown-it' )
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err

  hljs = require 'highlight.js'

  markdownIt = new markdown_it {
    langPrefix: 'hljs '
    highlight: (string, lang) =>
      try
        if lang
          return hljs.highlight(lang, string).value

        return hljs.highlightAuto(string).value
      catch err
        console.error err
      return ''
  }

  template = Router.expand_path 'sitefile-client:view.pug', ctx

  name: 'markdown-it'
  aliases: 'markdown-it' # XXX: cannot use alias while only req. routers are loaded
  # Iow. some config/install process or action needs to set the explicit
  # alias-router map per instance.
  label: 'Markdown HTML publisher'
  usage: """
    markdown-it:**/*.md
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
              cache: false
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
      sfpugOpts = _.merge {}, rctx.route.options.pug, {
        tpl: template
      }

      # Prepare to wrap markdown output with template using pug router
      sfpug = ctx._routers.get 'pug'
      [ opts, markdownItTpl ] = sfpug.compile sfpugOpts, rctx
      sitefile.log 'Markdown-It default publisher'

      # Respond to request and finish response using pug.publish helper
      ( req, res ) ->
        sitefile.log 'Markdown-It default HTML publish', rctx.res.path

        data = fs.readFileSync rctx.res.path
        sfpug.publish res, markdownItTpl, {
            main: ''
            document: markdownIt.render data.toString()
            footer: ''
          }, rctx
