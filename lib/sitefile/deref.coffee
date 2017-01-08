http = require 'http'
URL = require 'url'
# TODO see if this improves things request = require 'request'
rp = require 'request-promise'
Promise = require 'bluebird'



clientAcc = \
  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'

client_opts = ( { url, accType = null, reqType, opts = {} } ) ->
  if not accType and not reqType
    reqType = 'application/json'
  if not opts.headers
    opts.headers = {
      "Accept-Type": accType or reqType
    }
  if url
    opts.url = url
  if not opts.host
    u = URL.parse opts.url
    opts.host = u.host
    opts.port = u.port
    opts.path = u.path+'?'+u.query
  opts


# TODO: follow redirects
promise_resource = ( deref_args ) ->

  opts = client_opts deref_args

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
          else if reqType and contentType != reqType
            error = new Error("Invalid content-type.\n" +
                        "Expected #{reqType} but received #{contentType}")
          if error
            console.log error.message
            # consume response data to free up memory
            res.resume()
            reject error.message
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


module.exports =
  client_headers:
    accept_type: clientAcc
  promise:
    http_get: promise_http_get
    resource: promise_resource

