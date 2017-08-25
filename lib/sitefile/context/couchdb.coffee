###
###

_ = require 'lodash'


# Extension prototypes for sitefile's Context
module.exports = ( ctx ) ->
  
  name: 'sf-couchdb-context-proto'
  type: 'context-prototype'

  prototype:

    get_metadata_express: ( req, res ) ->
      ref = req.originalUrl
      if ref of @routes.resources
        rctx = @routes.resources[ref]
        rctx.get_metadata()

    get_metadata: ->

    set_metadata: ->
      db.insert @_data, rctx.res.ref, ( err, body ) ->
        
