# Sitefile CouchDB metadata context.
# 
# Aim is to abstract both access to a generic URL-JSON document store, and to
# Offer modes of resource request 
# 
_ = require 'lodash'


# Extension prototypes for sitefile's Context
module.exports = ( ctx ) ->
  
  name: 'sf-couchdb-context-proto'
  type: 'context-prototype'

  prototype:

    # Return resource metadata for Express request object
    get_metadata_express: ( req, res ) ->
      ref = req.originalUrl

      console.log 'get_metadata_express', ref, @res.ref
      return

      # Look for URL path ref, but ...
      unless ref of @routes.resources
        throw new Error "There is no router context at #{ref}"

      rctx = @routes.resources[ref]
      return rctx.get_metadata()

    # TODO:
    get_metadata: ->
      console.log 'TODO get_metadata', self.config.domain, self.res

    set_metadata: ->
      db.insert @_data, rctx.res.ref, ( err, body ) ->
        
