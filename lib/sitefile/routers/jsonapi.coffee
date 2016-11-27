

module.exports = ( ctx ) ->

  name: "jsonapi"
  usage: """
  """

  route:
    api:
      handler: '.api_prefix'
          
  generate:
    api_prefix: ( rctx ) ->
      # TODO: response with API json
      #ctx.app.get ctx.site.base+rctx.name+'.json', (req, res) ->
      ( req, res ) ->
        res.type 'application/vnd.api+json'
        res.end()

