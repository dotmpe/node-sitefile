_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for gwc: handler
module.exports = ( ctx={} ) ->


  name: 'gwc'
  label: 'Google Web components'
  usage: """
    gwc:**/*.pug
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
              html:
                prologue: ''
                header: ''
                main: ''
                document: ''
                footer: ''
                epilogue: ''

  generate:

    default: ( rctx ) ->
      pug = ctx._routers.get 'pug'
      ( req, res ) ->
        sitefile.log 'gwc', 'default html publish', rctx.res.path

        pugOpts = _.defaultsDeep {}, rctx.route.options.pug, {
          tpl: rctx.res.path
          merge:
            ref: rctx.res.ref
            gwc:
              clientId: ""
              chart:
                options: req.query.options or '{"title": "Distribution of days in 2001Q1"}'
                cols: req.query.cols or '[{"label":"Month", "type":"string"}, {"label":"Days", "type":"number"}]'
                rows: req.query.rows or '[["Jan", 31],["Feb", 28],["Mar", 31]]'
                style: "height: 20em"
              sheets:
                tabId: "1"
                style: "height: 20em"
              map:
                style: "height: 20em"
                api_key: ctx.gwc.map_api_key
        }

        pugOpts.merge.html.main = pug.compile pugOpts
        pugOpts.tpl = './lib/sitefile/client/view.pug'

        res.type 'html'
        res.write pug.compile pugOpts
        res.end()



