

# Given sitefile-context, export metadata for jsonary: handler
module.exports = ( ctx={} ) ->

  try
    jsonary = require 'jsonary'
  catch
    return

  #console.log jsonary
  #console.log jsonary.getData

  name: 'jsonary'
  label: 'Jsonary'
  usage: """
    jsonary:**/*.jsonary
  """

  # generators for Sitefile route handlers
  generate:
    default: ( spec, ctx={} ) ->
      #fn = spec + '.json'
      ( req, res ) ->
        res.write "Jsonary #{spec}"
        res.end()

