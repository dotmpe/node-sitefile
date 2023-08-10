{ Server } = require("socket.io")

module.exports = ( ctx ) ->

  # Create socket.io endpoint for Express server instance
  console.log 'SIO: creating socket.io endpoint on Express instance',
    ctx.site.netpath+'/socket.io/...'
  io = new Server(ctx.server)
 
  # TODO: now should config/init some sort of server for client, however
  # client is really beyond sitefile scope. Currently sf-v0 is a prototype
  # with different ways to bootstrap *a* client using (D)HTML, which like
  # the routes map can be completely different per Sitefile.

  # For now, the browser end of the SIO conn is done in
  # client/sf-v0/component/window

  io.on 'connection', (socket) ->
    console.log "SIO: Connected on socket",
      socket.conn.id, socket.conn.remoteAddress

    socket.on 'disconnect', ->
      console.log "SIO: Client", socket.conn.id, "disconnected"

  # Standard Sf router object

  name: 'Socket.IO'
  label: 'Socket.IO Publisher'
  usage: """
  """

  defaults:
    handler: 'info'

  generate:
    # XXX: could serve page with client that connects to SIO,
    # but no explicit route handlers are currenty provided to sitefile
    # except this 'info' example
    info: ( rctx ) ->
      ( req, res, next ) ->
        res.type 'text/plain'
        res.status 500
        res.write "What to do."
        res.end()
