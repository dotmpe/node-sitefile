###
###
_ = require 'lodash'
path = require 'path'
jade = require 'jade'


# Given sitefile-context, export metadata for jade: handlers
module.exports = ( ctx={} ) ->

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


