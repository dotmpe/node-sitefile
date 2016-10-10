###
###
_ = require 'lodash'
path = require 'path'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for pug: handlers
module.exports = ( ctx={} ) ->

  try
    pug = require 'pug'
  catch
    return


  #_.defaults ctx,

  name: 'pug'
  label: 'Pug templates'
  usage: """
    pug:**/*.pug
  """

  # generators for Sitefile route handlers
  generate: ( rsctx ) ->

    ( req, res ) ->
      sitefile.log 'Pug compile', rsctx.path
      tpl = pug.compileFile rsctx.path
      res.write tpl ctx
      res.end()


