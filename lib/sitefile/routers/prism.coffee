###
TODO Uses js-prism to render preformatted plain text with syntax
http://prismjs.com/
###
fs = require 'fs'
jade = require 'jade'


# Given sitefile-context, export metadata for prism: handlers
module.exports = ( ctx={} ) ->

  tpl = jade.compileFile './lib/sitefile/routers/prism.jade'

  name: 'prism'
  label: 'Source browser with Prism Syntax Highlighter'
  usage: """
    prism:
    prism:**/*.*
  """

  generate: ( path, ctx={} ) ->

    ( req, res ) ->
      ctx.source = req.params[0]
      ctx.format = 'jade'
      data = fs.readFileSync req.params[0]
      ctx.code = data.toString()
      ctx.lines = ctx.code.split('\n')
      res.write tpl ctx
      res.end()





