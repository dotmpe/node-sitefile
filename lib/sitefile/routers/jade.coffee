###
###
_ = require 'lodash'
path = require 'path'


# Given sitefile-context, export metadata for jade: handler
module.exports = ( ctx={} ) ->

  try
    jade = require 'jade'
  catch
    return


  #_.defaults ctx,

  name: 'jade'
  label: 'Jade templates'
  usage: """
    jade:**/*.jade
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->

    ( req, res ) ->
      tpl = jade.compileFile spec + '.jade'
      res.write tpl ctx
      res.end()


