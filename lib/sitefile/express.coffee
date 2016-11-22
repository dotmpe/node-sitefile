path = require 'path'
express = require 'express'
qs = require 'qs'


init_express = ( app, ctx={} ) ->

  if not ctx.showStackError?
    ctx.showStackError = true
  app.set 'showStackError', ctx.showStackError

  #app.use express.static path.join ctx.noderoot, 'public'


parse_simple_types = ( query ) ->

  for key, value of query
    if value in [ 'true', 'false' ]
      query[key] = Boolean value
    else if not isNaN parseInt value, 10
      query[key] = parseInt value, 10
    else if typeof value == "object"
      parse_simple_types query[key]
        

module.exports = (ctx={}) ->

  app = express()

  #ctx.envname = app.get 'env'
  app.set 'env', ctx.envname

  if process.env.SITEFILE_PORT
    ctx.site.port = process.env.SITEFILE_PORT

  app.set 'port', ctx.site.port

  ctx.server = require("http").createServer(app)

  init_express( app, ctx )

  ctx.static_proto = express.static

  ctx.redir = ( ref, p ) ->
    # Express redir handler
    ctx.app.all ref, (req, res) ->
      res.redirect p

  app.set 'query parser', ( query_str ) ->
    query = qs.parse query_str
    parse_simple_types query
    query

  app


