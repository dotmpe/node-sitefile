{ Server } = require("socket.io")

module.exports = ( ctx ) ->
  io = new Server(ctx.server)

  io.on 'connection', (socket) ->
    console.log "Connected on socket"
    socket.on 'disconnect', ->
      console.log "User disconnected"
  
  name: 'Socket.IO'
  label: 'Socket.IO Publisher'
  usage: """
  """

  defaults:
    handler: 'info'

  generate:
    info: ( rctx ) ->
      ( req, res, next ) ->
        res.type 'text/plain'
        res.status 500
        res.write "What to do."
        res.end()
