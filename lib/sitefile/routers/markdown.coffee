_ = require 'lodash'
fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for markdown: handlers
module.exports = ( ctx={} ) ->

  try
    md = require( 'markdown' ).markdown
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err


  name: 'markdown'
  label: 'Markdown HTML publisher'
  usage: """
    markdown:**/*.md
  """

  generate:
    default: ( rctx ) ->

      ( req, res ) ->
        sitefile.log 'Markdown publish', rctx.res.path
        data = fs.readFileSync rctx.res.path
        doc = md.toHTML data.toString()
        res.type 'html'
        res.write doc
        res.end()



