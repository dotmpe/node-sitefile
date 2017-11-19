module.exports = ( ctx ) ->

  name: 'sf-test'
  label: 'Sitefile test router'

  description: ""
  usage: ""
  defaults: {}

  generate:
    default: ( rctx ) ->

      # rctx.res - data for route spec
      
      ( req, res ) ->

        # rctx.route - data for route instance, and actual request
      
        data =
          req: req.params
          res: rctx.res
          route: rctx.route
        res.json data
