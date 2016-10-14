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

  generate: ( rsctx ) ->

    ( req, res ) ->
      sitefile.log 'Markdown publish', rsctx.path
      data = fs.readFileSync rsctx.path
      doc = md.toHTML data.toString()
      res.write doc
      res.end()



