###
TODO Uses js-prism to render preformatted plain text with syntax
http://prismjs.com/
###
_ = require 'lodash'
fs = require 'fs'
jade = require 'jade'


# Given sitefile-context, export metadata for prism: handlers
module.exports = ( ctx={} ) ->

  _.defaults ctx, lazyCompile: true

  if not ctx.lazyCompile
    tpl = jade.compileFile './lib/sitefile/routers/prism-js-view.jade'

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
      if ctx.lazyCompile
        tpl = jade.compileFile './lib/sitefile/routers/prism-js-view.jade'
      res.write tpl ctx
      res.end()

