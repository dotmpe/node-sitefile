

module.exports = ( ctx ) ->

  name: "cdn"
  usage: """

    TODO:

    1. prefetch, cache href. serve first ref (file/href) that exists
    2. detailed parameterization; generic sets for dev (source-map), or
       production (min), or specific settings like per module version.

    Sitefile
      /path/to/cdn:
        cdn:
          <module>: [
            //alt-1
            //alt-2
          ]
    or:
      /path/to/cdn-from-json: cdn:cnd.json

    Routes
      cdn: cdn.json
      cdn.json:
        cnd: ....
      cdn/<module>?...
      api/cdn.json:
        meta: []
        data: [{
          module: "<module>"
        }]
      api/cnd/<module>: static or redir
      
  """

  default_handler: 'cdn'

  generate:
    cdn: ( rctx ) ->
      ( req, res ) ->
        res.redir()
    index: ( rctx ) ->
      data: ctx.cdn
        
      

