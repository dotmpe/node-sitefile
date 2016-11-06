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
  generate: ( rsctx ) ->
    ( req, res ) ->
      sitefile.log "Stylus compile", rsctx.path
      data = fs.readFileSync rsctx.path
      res.write stylus.render data.toString()
      res.end()

