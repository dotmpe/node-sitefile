module.exports = ( ctx ) ->

  name: "jsonapi"

  usage: """
    api: jsonapi.prefix:#
  """

  generate:
    prefix: ( rctx ) ->
      # TODO: response with API json for any known route
      #ctx.app.get ctx.site.base+rctx.name+'.json', (req, res) ->
      ( req, res ) ->
        res.type 'application/vnd.api+json'
        res.end()
    index: ( rctx ) ->
      # respond with route list wrapped in json-api document
      data:
        data: rctx.context.route
        meta: {}
      meta:
        type: {}
