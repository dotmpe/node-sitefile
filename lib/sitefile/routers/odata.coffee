require 'odata-server'

# Given sitefile-context, export metadata for odata: handlers
module.exports = ( ctx={} ) ->

  name: 'odata'
  label: 'OData Server'
  usage: """
    odata:**/*.coffee
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->

    #fn = spec + '.coffee'
    odata_type = require spec


    ( req, res ) ->
      res.write odata._compileFile fn
      res.end()



