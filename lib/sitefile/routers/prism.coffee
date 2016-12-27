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

  view = './lib/sitefile/routers/prism/view.pug'
  view0 = './lib/sitefile/routers/prism/view-0.pug'

  #if not ctx.lazyCompile
  #  tpl = pug.compileFile view

  generate = ( view ) ->
    ( req, res ) ->

      data = fs.readFileSync req.params[0]

      # XXX: if not tpl
      tpl = pug.compileFile view

      ctx.source = req.params[0]
      ctx.format = 'pug'
      ctx.code = data.toString()
      ctx.lines = ctx.code.split('\n')

      res.type 'html'
      res.write tpl ctx
      res.end()

  name: 'prism'
  label: 'Source browser with Prism Syntax Highlighter'
  usage: """
    prism:
    prism:**/*.*
  """

  generate:
    default: ( path, ctx={} ) ->
      generate(view)
    view0: ( path, ctx={} ) ->
      generate(view0)

