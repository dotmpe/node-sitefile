
module.exports = ( ctx ) ->

  name: 'metadata'
  label: 'Sitefile metadata middleware'
  type: 'middleware'

  description: "Load additional data from YML/JSN as-is files at routes"
  usage: "Add path to this module to Sitefile paths.packages, and configure package"

  passthrough: ( req, res, next ) ->
    #console.log "Metadata middleware here for", req.path
    next()

