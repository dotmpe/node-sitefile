###
###
fs = require 'fs'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for stylus: handlers
module.exports = ( ctx={} ) ->

  try
    stylus = require 'stylus'
  catch
    return

  name: 'stylus'
  label: 'Stylus Stylesheet publisher'
  usage: """
    stylus:**/*.stylus
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->
    fn = spec + '.styl'
    ( req, res ) ->
      sitefile.log "Stylus compile", fn
      data = fs.readFileSync fn
      res.write stylus.render data.toString()
      res.end()

