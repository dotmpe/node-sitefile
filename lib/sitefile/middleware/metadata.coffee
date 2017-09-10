# ## Sitefile Metadata middleware Module
#
# Look-up data for and add MIME-headers to Response, based on the metadata
# associated with either or both the request URL and the router path.
#
#
# ### Details
# The storage implementation is contained in the Sitefile context by the CouchDB
# context-prototype mixin. Seen from the middleware, the usable data is the
# request URL, and some bits that may have been parsed at this point such as the
# baseURL. But only with a specific route, which may be a pattern, can we access
# the in-memory Sitefile structure and get the router context.
#
# Storage has a generic interface to query a URL to JSON document mapping. These
# are absolute URL's including netpath and scheme, maybe event fragments. (The
# sort that appear in documents as external hyperlink references or in a bookmark
# collection).
#
# But from the Sitefile middleware its ofcourse only the server part (up to
# the fragment) that is seen, and also the scheme and host parts are fixed. Next
# issue, is that to access the routed-path within Express, we need to wait until
# the router is running. Or else ``req.route`` is not populated yet.
#
# E.g. the 'finish' event on the Response could access ``route.path``. XXX: idk.
# which events Response has exactly, but 'headers' which was removed with Connect
# 3.x seems the best fit. So using the replacement 'on-headers' module for that.
#
# Leaving only the problem that the middleware cannot offer the router access to
# the middleware.

path = require 'path'
onHeaders = require 'on-headers'


module.exports = ( ctx ) ->

  # ### Static module
  # configured using pre-constructor ctx object
  name: 'metadata'
  label: 'Sitefile metadata middleware'
  type: 'middleware'
  description: "Load additional data from YML/JSN as-is files at routes"
  usage: "TODO: Add path to this module to Sitefile paths.packages, \
 and configure package"

  # Middleware function
  passthrough: ( req, res, next ) ->

    ctx = req.app.get 'context'
    ref = req.originalUrl

    return next() # FIXME

    onHeaders( res, ->
      console.log 'metadata:', ref, 'route:', req.path, req.route.path
      res.setHeader "X-Sf-Metadata-Path", req.route.path
    )
    res.setHeader "X-Sf-Metadata", "blah"

    ###
    (->

      if ref of @routes.resources
        rctx = @routes.resources[ref]

    ).bind(ctx)()
    ###

    next()

