###
###
_ = require 'lodash'
path = require 'path'


# Given sitefile-context, export metadata for stylus: handlers
module.exports = ( ctx={} ) ->

  try
    stylus = require 'stylus'
  catch
    return


  #_.defaults ctx,

  name: 'stylus'
  label: 'Server Generated Stylesheets'
  usage: """
    stylus:**/*.stylus
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->

    ( req, res ) ->
      tpl = stylus.compileFile spec
      res.write tpl ctx
      res.end()




