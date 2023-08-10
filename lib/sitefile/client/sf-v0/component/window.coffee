define 'sf-v0/component/window', [
  "/socket.io/socket.io.js"
], ( io ) ->

  socket = io()

  console.log "SIO conn est"

  socket.on "connect", ->
    console.log "SIO conn init"+
      "##{socket.id} v#{io.protocol} con:#{socket.connected}"

  class Window
    constructor: ->
      super()

#
