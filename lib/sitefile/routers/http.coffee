_ = require 'lodash'
http = require 'http'
path = require 'path'
fs = require 'fs'
URL = require 'url'

Router = require '../Router'

Promise = require 'bluebird'

sitefile = require '../sitefile'


clientAcc = \
  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'

promise_resource = ( { url, accType = null, reqType, opts = {} } ) ->

  if not accType and not reqType
    reqType = 'application/json'
  if not opts.headers
    opts.headers = {
      "Accept-Type": accType or reqType
    }
  if url
    opts.url = url

  new Promise (resolve, reject) ->
    console.log 'promise_resource', opts
    try
      http
        .get opts, ( res ) ->
          statusCode = res.statusCode
          contentType = res.headers['content-type']
          error = null
          if statusCode != 200
            error = new Error("Request Failed.\n" +
                              "Status Code: #{statusCode}")
          else if reqType and contentType != reqType
            error = new Error("Invalid content-type.\n" +
                        "Expected #{reqType} but received #{contentType}")
          if error
            console.log(error.message)
            # consume response data to free up memory
            res.resume()
            return

          res.setEncoding('utf8')
          rawData = ''
          res.on 'data', (chunk) -> rawData += chunk
          if reqType == 'application/json'
            res
              .on 'end', ->
                try
                  parsedData = JSON.parse rawData
                  resolve [ parsedData, contentType ]
                catch e
                  console.log e.message
                  reject e.message
              .on 'error', (e) ->
                console.log("Got error: #{e.message}")
                reject e

          else
            res
              .on 'end', ->
                resolve [ rawData, contentType ]
              .on 'error', (e) ->
                console.log("Got error: #{e.message}")
                reject e
    catch err
      reject err



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
    resource: promise_resource

  generate:

    default: ( rctx ) ->

      ( req, res ) ->
        url = rctx.route.options.spec + req.params.ref
        promise_resource(
          url: url
          accType: 'application/json'
        ).then (data) ->
          res.type 'json'
          res.write JSON.stringify data
          res.end()

    ref: ( rctx ) ->
      ( req, res ) ->
        if not req.params or req.params.length > 1
          throw new Error "http.ref requires 1 parameter"
        url = req.params[0]
        sitefile.log "http.ref", url
        promise_resource(
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

    res: ( rctx ) ->
      ( req, res ) ->
        if not req.params or req.params.length > 1
          throw new Error "http.res requires 1 parameter"
        url = req.params[0]
        u = URL.parse url
        port = parseInt(u.port)
        sitefile.log "http.res", url
        promise_resource(
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

    # Redirect/proxy named domains/netpaths?
    site: ( rctx ) ->
      # TODO: look along path using sitefile function
      nso = require path.join ctx.cwd, rctx.route.spec
      ( req, res ) ->
        base = nso.names[  req.params.site ]
        url = base.base+'/'+req.params.path
        u = URL.parse req.protocol+':'+url
        port = parseInt(u.port)
        promise_resource(
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


