_ = require 'lodash'
path = require 'path'
fs = require 'fs'
URL = require 'url'


sitefile = require '../sitefile'
deref = require '../deref'

clientAcc = deref.client_headers.accept_type


module.exports = ( ctx ) ->


  # Return obj. w/ metadata & functions
  name: 'http'

  defaults:
    route:
      options:
        compile: {}
        merge: {}
        spec:
          url: 'http://nodejs.org/dist/index.json'

  promise:
    resource: deref.promise.http_get

  generate:

    # Fetch remote JSON
    default: ( rctx ) ->

      ( req, res ) ->
        url = rctx.route.spec + req.params.ref
        ctx._routers.get('http').promise.resource(
          url: url
          accType: 'application/json'
        ).then (data) ->
          res.type 'json'
          res.write JSON.stringify data
          res.end()

    # Do a HTTP HEAD request
    ref: ( rctx ) ->
      ( req, res ) ->
        if not req.params or req.params.length > 1
          throw new Error "http.ref requires 1 parameter"
        url = req.params[0]
        sitefile.log "http.ref", url
        ctx._routers.get('http').promise.resource(
          opts: {
            method: 'head'
          }
          url: url
          accType: clientAcc
        ).then( ( [ data, contentType ] ) ->
          res.type contentType
          res.write data
          res.end()
        ).catch ( err ) ->
          res.status 500
          res.type 'txt'
          res.write err
          res.end()

    # 'Proxy' a remote resource
    res: ( rctx ) ->
      ( req, res ) ->
        if not req.params or req.params.length > 1
          throw new Error "http.res requires 1 parameter"
        url = req.params[0]
        u = URL.parse url
        port = parseInt(u.port)
        sitefile.log "http.res", url
        ctx._routers.get('http').promise.resource(
          opts: {
            host: u.hostname
            port: port or 80
            path: u.path
          }
          accType: clientAcc
        ).then( ( [ data, contentType ] ) ->
          res.type contentType
          res.write data
          res.end()
        ).catch ( err ) ->
          res.status 500
          res.type 'txt'
          res.write err
          res.end()

    # Redirect package/format to CDN or other library
    vendor: ( rctx ) ->
      cdnjson = path.join ctx.cwd, rctx.route.spec
      if not fs.existsSync cdnjson
        cdnjson = path.join ctx.sfdir, rctx.route.spec
      if not fs.existsSync cdnjson
        log.warn "CDN requires JSON config"
        return
      cdn = require cdnjson
      if not cdn
        cdn = {}
        log.warn "CDN config is empty"
      ( req, res ) ->
        f = _.defaultsDeep {}, req.params
        if f.format not of cdn
          err = "No format #{f.format}"
          res.status 500
          res.write err
          res.end()
          throw new Error err
        if f.package not of cdn[f.format].http.packages
          err = "No #{f.format} package #{f.package}"
          res.status 500
          res.write err
          res.end()
          throw new Error err
        ext = cdn[f.format].http.ext
        res.redirect cdn[f.format].http.packages[f.package]+ext


