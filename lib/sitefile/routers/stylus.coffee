fs = require 'fs'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for stylus: handlers
module.exports = ( ctx ) ->

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
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "Stylus compile", rctx.res.path
        data = fs.readFileSync rctx.res.path
        res.type 'css'
        res.write stylus.render data.toString()
        res.end()
