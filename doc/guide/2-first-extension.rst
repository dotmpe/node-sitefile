Adding a local extension router
===============================

This is step two of the setup guide, `getting started`_.

Setting up a site with Sf will involve using file formats the can be parsed
into structured representations, and served in ways that a browser understands.
Iow. content that can be rendered as hypertext, scripts, stylesheets or other
(streamable) media are initial candidates.

Sf can be used to prototype such resources for those that want to write coffee
script or javascript.

The following is an setup for a 0.0.5 Sf router.

``routers/myRouter.coffee``::

    module.exports = ( ctx ) ->

      name: 'myRouter'

      globspec: false
      expand: ( spec ) ->

      defaults:
        example-argument:
          routes:
            options: {}

      generate:
        default: ( rctx ) ->
          ( req, res ) ->
            res.write('Hello World!')
            res.end()

        data: ( rctx ) ->
          res: data: {}

        data-async: ( rctx ) ->
          res: data: -> {}

        example-argument: ( rctx ) ->
          res: data: rctx.res.options

        mapping: ( rctx ) ->
          route:
            '.html': '.view'
            '.js': '.script'
            '.json': '.data-example'

        data-example: ( rctx ) ->
          res: data: [
            id: 1, name: 'one'
            id: 2, name: 'two'
            id: 3, name: 'three'
          ]

