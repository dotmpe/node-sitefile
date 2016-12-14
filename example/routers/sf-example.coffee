

module.exports = ( ctx ) ->

  name: 'sf-example'

  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        res.type 'text'
        res.write 'Sitefile example'
        res.end()

    data1: ( rctx ) ->
      res:
        data: ->
          'sf-example': 'dynamic'

    data2: ( rctx ) ->
      res:
        data:
          'sf-example': 'static'
      

