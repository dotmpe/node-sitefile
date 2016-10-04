_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'

md = require( 'markdown' ).markdown


# Given sitefile-context, export metadata for markdown: handler
module.exports = ( ctx={} ) ->

  name: 'markdown'
  label: 'Markdown HTML publisher'
  usage: """
    markdown:**/*.md
  """

  generate: ( spec, ctx={} ) ->

    fn = spec + '.md'

    ( req, res ) ->
      sitefile.log 'Markdown publish', fn
      data = fs.readFileSync fn
      doc = md.toHTML data.toString()
      res.write doc
      res.end()




