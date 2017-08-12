path = require 'path'

module.exports = ( ctx ) ->

  name: 'metadata'
  label: 'Sitefile metadata middleware'
  type: 'middleware'

  description: "Load additional data from YML/JSN as-is files at routes"
  usage: "Add path to this module to Sitefile paths.packages, and configure package"

  passthrough: ( req, res, next ) ->

    ctx = req.app.get 'context'
    ref = req.originalUrl

    (->

      if ref of @routes.resources
        rctx = @routes.resources[ref]

    ).bind(ctx)()

    #m = req.app.get 'metadata'
    #if m
    #  console.log 'TODO: fetch metadata for', path.join m, req.originalUrl

    next()


