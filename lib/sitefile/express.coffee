path = require 'path'
express = require 'express'


init_express = ( app, ctx={} ) ->

  if not ctx.showStackError?
    ctx.showStackError = true
  app.set 'showStackError', ctx.showStackError

  #app.use express.static path.join ctx.noderoot, 'public'


module.exports = (ctx={}) ->

  app = express()

  #ctx.envname = app.get 'env'
  app.set 'env', ctx.envname

  if not ctx.port
    ctx.port = process.env.PORT || 3000
  app.set 'port', ctx.port

  ctx.server = require("http").createServer(app)

  init_express( app, ctx )

  ctx.static_proto = express.static

  ctx.redir = ( ref, p ) ->
    # Express redir handler
    ctx.app.all ref, (req, res) ->
      res.redirect p

  app

