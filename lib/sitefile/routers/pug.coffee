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
  generate: ( spec, ctx={} ) ->

    fn = spec + '.pug'

    ( req, res ) ->
      sitefile.log 'Pug compile', fn
      tpl = pug.compileFile fn
      res.write tpl ctx
      res.end()


