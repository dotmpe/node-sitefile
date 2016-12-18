fs = require 'fs'
path = require 'path'
_ = require 'lodash'


module.exports = ( ctx ) ->

  name: "cdn"
  usage: """

    TODO:

    1. prefetch, cache href. serve first ref (file/href) that exists
    2. detailed parameterization; generic sets for dev (source-map), or
       production (min), or specific settings like per module version.

    Sitefile
      /path/to/cdn:
        cdn:
          <module>: [
            //alt-1
            //alt-2
          ]
    or:
      /path/to/cdn-from-json: cdn:cdn.json

    Routes
      cdn: cdn.json
      cdn.json:
        cdn: ....
      cdn/<module>?...
      api/cdn.json:
        meta: []
        data: [{
          module: "<module>"
        }]
      api/cdn/<module>: static or redir
      
  """

  default_handler: 'cdn'

  generate:
    cdn: ( rctx ) ->
      cdnjson = path.join ctx.cwd, rctx.route.spec
      if not fs.existsSync cdnjson
        cdnjson = path.join ctx.sfdir, rctx.route.spec
      if not fs.existsSync cdnjson
        log.warn "CDN requires JSON config"
        return
      console.log 'CDN', cdnjson, JSON.stringify rctx.res
      cdn = require cdnjson
      ( req, res ) ->
        f = _.defaultsDeep {}, req.params
        ext = cdn[f.format].http.ext
        if f.format not of cdn
          err = "No format #{f.format}"
          res.type 500
          res.write err
          res.end()
          throw new Error err
        if f.package not of cdn[f.format].http.packages
          err = "No #{f.format} package #{f.package}"
          res.type 500
          res.write err
          res.end()
          throw new Error err
        res.redirect cdn[f.format].http.packages[f.package]+ext
    index: ( rctx ) ->
      data: ctx.cdn
        
