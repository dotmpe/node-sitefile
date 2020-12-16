fs = require 'fs'
http = require 'http'
URL = require 'url'
# TODO see if this improves things request = require 'request'
rp = require 'request-promise'
yaml = require 'js-yaml'
Promise = require 'bluebird'


clientAcc = \
  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'

client_opts = ( { url, accType = null, reqType, opts = {} } ) ->
  if not url and not opts.path
    throw new Error "URL or path required"
  if not accType and not reqType
    reqType = 'application/json'
  if not opts.headers
    opts.headers = {
      "Accept-Type": accType or reqType
    }
  if url
    opts.url = url
  if not opts.host and not opts.hostname
    if not opts.url
      opts.host = 'localhost'
    else
      u = URL.parse opts.url
      if u.host then opts.host = u.host
      if u.port then opts.port = u.port
      if u.path then opts.path = u.path
      if u.query then opts.path = opts.path+'?'+u.query
  opts.reqType = reqType
  opts


promise_resource = ( deref_args ) ->

  opts = client_opts deref_args

  # TODO: follow redirects
  rp(opts)


promise_http_get = ( deref_args ) ->

  opts = client_opts deref_args

  new Promise (resolve, reject) ->
    try
      http
        .get opts, ( res ) ->
          statusCode = res.statusCode
          contentType = res.headers['content-type']
          error = null
          if statusCode != 200
            error = new Error("Request Failed.\n" +
                              "Status Code: #{statusCode}")
          else if opts.reqType and not contentType.startsWith opts.reqType
            error = new Error("Invalid content-type.\n" +
                        "Expected #{opts.reqType} but received #{contentType}")
          if error
            console.warn error.message
            # consume response data to free up memory
            res.resume()
            reject error.message
            return

          res.setEncoding('utf8')
          rawData = ''
          res.on 'data', (chunk) -> rawData += chunk
          if opts.reqType == 'application/json'
            res
              .on 'end', ->
                try
                  parsedData = JSON.parse rawData
                  resolve [ parsedData, contentType ]
                catch e
                  console.warn e.message
                  reject e.message
              .on 'error', (e) ->
                console.warn("Got error: #{e.message}")
                reject e

          else
            res
              .on 'end', ->
                resolve [ rawData, contentType ]
              .on 'error', (e) ->
                console.warn("Got error: #{e.message}")
                reject e
    catch err
      reject err

# TODO:
promise_file = ( fn, rctx ) ->
  promise_metadata( fn, rctx, false )

promise_metadata = ( fn, rctx, parse=true ) ->
  if not fn
    if not rctx.sfdir or not rctx.route.spec
      throw new Error "deref.promise.file: Base and spec required"
    fn = rctx.sfdir+ '/'+ rctx.route.spec
  new Promise ( resolve, reject ) ->
    fs.readFile fn, ( err, data ) ->
      if err
        return reject err
      if parse
        try
          resolve parse_metadata fn, data, rctx
        catch e
          reject e
      else resolve String(data)


# XXX: may need to hook into some data handling lib from here
parse_metadata = ( fn, data, rctx ) ->
  if /\.json$/.test fn
    return JSON.parse String(data)
  if /\.yaml|yml$/.test fn
    return yaml.safeLoad String(data)
  else throw Error "Unparsed metadata #{fn}"

local_or_remote = ( rctx ) ->
  if not rctx.res.src.host or (
    rctx.res.src.host == rctx.site.host and
    rctx.res.src.host == rctx.site.host
  )
    # TODO lookup router or call handler somewhere
    #rctx._routers.get('')
    #promise_file null
  else
    promise_resource {
      url: rctx.res.src.toString()
      accType: 'application/json'
    }


module.exports =
  client_headers:
    accept_type: clientAcc
  promise:
    http_get: promise_http_get
    resource: promise_resource
    file: promise_file
    metadata: promise_metadata
    local_or_remote: local_or_remote
  metadata:
    parse: parse_metadata
