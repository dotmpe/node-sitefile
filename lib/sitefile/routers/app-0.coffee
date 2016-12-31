fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'
_ = require 'lodash'


module.exports = ( ctx ) ->

  pugrouter = require('./pug') ctx

  # Include build artefacts (JS, CSS and Font)
  # Lodash, Bootstrap, jQuery
  build = data: {}, files: {}
  build.files =
    css: 'dist/app-0.css'
    js: 'dist/app-0/main.js'
    font: 'dist/app-0'
  build.data = {}
    #css: fs.readFileSync build.files.css
    #js: fs.readFileSync build.files.js
    #font: fs.readFileSync build.files.font

  name: 'app-0'
  label: 'HTML5 Sitefile Client prototype'
  usage: """

    app-0:**/*.app-0

  """
  # generators for Sitefile route handlers
  generate:

    default: ( rctx ) ->
      ( req, res ) ->

        opts = {
          stylesheets: urls: ['/app/v0/base.css']
          scripts: urls: [] #['/app/v0/base.js']
          clients: []
        }
        opts = _.defaultsDeep rctx.route.options, opts
        mainPugFn = path.join __dirname, 'app-0', 'main.pug'
        res.type 'html'
        res.write pugrouter.compile mainPugFn, {
          compile: rctx.route.options.compile
          merge:
            base: ctx.site.base+rctx.name
            script: ctx.site.base+rctx.name+'.js'
            options: opts
            query: req.query
            context: rctx
        }
        res.end()

    reader: ( rctx ) ->
      ( req, res ) ->

        readerPugFn = path.join __dirname, 'app-0', 'reader.pug'
        res.type 'html'
        res.write pugrouter.compile readerPugFn, {
          compile: rctx.route.options.compile
          merge:
            base: ctx.site.base+rctx.name
            script: ctx.site.base+rctx.name+'.js'
            options:
              stylesheets: urls: ['/app/v0/base.css']
              scripts: urls: ['/app/v0/base.js']
            query: req.query
            context: rctx
        }
        res.end()


    cdn_js: ( rctx ) ->
      if rctx.route.spec
        build.files.js = rctx.route.spec
      ( req, res ) ->
        build.data.js = fs.readFileSync build.files.js
        res.type 'js'
        res.write build.data.js
        res.end()

    cdn_css: ( rctx ) ->
      if rctx.route.spec
        build.files.css = rctx.route.spec
      ( req, res ) ->
        build.data.css = fs.readFileSync build.files.css
        res.type 'css'
        res.write build.data.css
        res.end()


