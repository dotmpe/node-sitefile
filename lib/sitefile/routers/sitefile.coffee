_  = require 'lodash'
URL = require 'url'

path = require 'path'
Router = require '../Router'
libconf = require '../../conf'
#libsitefile = require '../sitefile'


nested_dicts_to_menu_outline = ( data, map, name='' ) ->
  label: name
  icon: if data.icon then data.icon else 'star-empty'
  href: data.base
  items: (
    nested_dicts_to_menu_outline sub, map, name for name, sub of data.names
  )


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
    # TODO:
    resource: ( rctx ) ->
      data: {}
    handler: ( rctx ) ->
      data: {}
    global: ( rctx ) ->
      data: {}

    # TODO: generate menu from multiple sources. 
    menu: ( rctx ) ->
      ( req, res ) ->

    sites: ( rctx ) ->
      res:
        fmt: path.extname(rctx.res.ref).substring 1
        data: ->
          fn = if rctx.res.path then rctx.res.path else if rctx.route.spec.trim '#' then rctx.route.spec else 'sites.json'
          fn = Router.expand_path fn, ctx
          srcfmt = path.extname(fn).substring 1
          libconf.load_file fn, ext: ".#{srcfmt}"

    'sites-to-menu': ( rctx ) ->
      res:
        data: ->
          fn = if rctx.res.path then rctx.res.path else if rctx.route.spec.trim '#' then rctx.route.spec else 'sites.json'
          fn = Router.expand_path fn, ctx
          srcfmt = path.extname(fn).substring 1
          data = libconf.load_file fn, ext: ".#{srcfmt}"
          nested_dicts_to_menu_outline data, label: 'key()', items: 'names', href: 'base'

          ###
          # TODO: access other resource context by url
          if not rctx.res.src
            rctx.res.src = URL.parse \
              rctx.site.base+rctx.route.spec.trim '#'
          deref.promise.local_or_remote rctx
          ###

    default: ( rctx ) ->
      ( req, res ) ->
        res.type 'json'
        switch rctx.route.handler
          when "resolver" then res.write JSON.stringify rctx._data
          when "global" then res.write JSON.stringify ctx._data
          else res.write JSON.stringify _.defaults {}, rctx._data, ctx._data

        res.end()


