_  = require 'lodash'

sitefile = require '../sitefile'


module.exports = ( ctx ) ->

  name: 'sitefile'
  label: ''
  usage: """
    sitefile:**/*.json
  """

  defaults:
    default:
      route:
        options:
          sitefile_default_route_option_example_key: 1

  generate:
    resource: ( rctx ) ->
      data: {}
    handler: ( rctx ) ->
      data: {}
    global: ( rctx ) ->
      data: {}
    default: ( rctx ) ->

      ( req, res ) ->

        console.log 'sitefile', rctx.route.handler, 'ctx debug json'

        res.type 'json'

        switch rctx.route.handler
          when "resolver" then res.write JSON.stringify rctx._data
          when "global" then res.write JSON.stringify ctx._data
          else res.write JSON.stringify _.defaults {}, rctx._data, ctx._data

        res.end()


