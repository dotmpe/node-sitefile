###
###
_ = require 'lodash'
path = require 'path'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for jade: handlers
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

    fn = spec + '.jade'

    ( req, res ) ->
      sitefile.log 'Jade compile', fn
      tpl = jade.compileFile fn
      res.write tpl ctx
      res.end()


