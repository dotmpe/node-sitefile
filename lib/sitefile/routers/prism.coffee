###
TODO Uses js-prism to render preformatted plain text with syntax
http://prismjs.com/
###
_ = require 'lodash'
fs = require 'fs'
pug = require 'pug'


# Given sitefile-context, export metadata for prism: handlers
module.exports = ( ctx={} ) ->

  _.defaults ctx, lazyCompile: true

  if not ctx.lazyCompile
    tpl = pug.compileFile './lib/sitefile/routers/prism-js-view.pug'

  name: 'prism'
  label: 'Source browser with Prism Syntax Highlighter'
  usage: """
    prism:
    prism:**/*.*
  """

  generate:
    default: ( path, ctx={} ) ->
      ( req, res ) ->
        ctx.source = req.params[0]
        ctx.format = 'pug'
        data = fs.readFileSync req.params[0]
        ctx.code = data.toString()
        ctx.lines = ctx.code.split('\n')
        if ctx.lazyCompile
          tpl = pug.compileFile './lib/sitefile/routers/prism-js-view.pug'
        res.write tpl ctx
        res.end()

