
http = require 'http'
Promise = require 'bluebird'


promise_json = ( spec ) ->

  new Promise (resolve, reject) ->
    http.get( spec, ( res ) ->
      statusCode = res.statusCode
      contentType = res.headers['content-type']
      error = null
      if statusCode != 200
        error = new Error("Request Failed.\n" +
                          "Status Code: #{statusCode}")
      else if !/^application\/json/.test(contentType)
        error = new Error("Invalid content-type.\n" +
                    "Expected application/json but received #{contentType}")
      if error
        console.log(error.message)
        # consume response data to free up memory
        res.resume()
        return

      res.setEncoding('utf8')
      rawData = ''
      res.on 'data', (chunk) -> rawData += chunk
      res.on 'end', ->
        try
          parsedData = JSON.parse rawData
          resolve parsedData
        catch e
          console.log e.message
          reject e.message

      ).on 'error', (e) ->
        console.log("Got error: #{e.message}")
        reject e



module.exports = ( ctx ) ->

  # Return obj. w/ metadata & functions
  name: 'http'

  defaults:
    route:
      options:
        spec:
          url: 'http://nodejs.org/dist/index.json'

  promise:
    json: promise_json

  generate: ( rctx ) ->

    ( req, res ) ->
      promise_json(
        rctx.route.options.spec
      ).then (data) ->
        console.log 'resolve', arguments
        res.type 'json'
        res.write JSON.stringify data
        res.end()

