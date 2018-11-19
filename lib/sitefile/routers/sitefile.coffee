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
  label: 'Built-in routers serve sitefile parts, see core for internal API routes'
  usage: """
    sitefile.info:
    sitefile.info:
    sitefile.rctx:
    sitefile.ctx:
    sitefile.menu:
    sitefile.sites-to-menu:
    sitefile.sites:
  """

  defaults:
    global:
      default:
        options:
          pug:
            merge:
              scripts: []
              stylesheets: []
              clients: []

    default:
      route:
        options:
          sitefile_default_route_option_example_key: 1

  generate:

    # XXX: hardcoded redir for node-sitefile project
    default: ( rctx ) ->
      ( req, res ) ->
        # FIXME: want to query for mount point of handler(s), redirect there
        ctx.redir 'Sitefile/resource'

    info: ( rctx ) ->
      ( req, res ) ->
        d = _.defaults {}, rctx.site,
          execArgv: process.execArgv
          cwd: process.cwd()
          pid: process.pid
          platform: process.platform
          release: process.release
        if req.query.key
          res.type 'text/plain'
          res.write "#{d[req.query.key]}"
        else
          res.type 'json'
          res.write JSON.stringify d
        res.end()
     
    'pug-opts': ( rctx ) ->
      pugOpts = _.defaultsDeep {}, rctx.route.options.sitefile, {}
      pug = ctx._routers.get 'pug'
      opts = _.defaultsDeep {}, pugOpts, pug.defaults

      res:
        data: opts

    # sitefile.rctx - resource context
    rctx: ( rctx ) ->
      opts = _.defaultsDeep {}, rctx.route.options.sitefile, {}

      res:
        data: rctx._data

    # sitefile.ctx - global context including static sitefile, rc, modules and instances
    ctx: ( rctx ) ->
      #throw Error("FIXME rctx.route.resource to JSON, see core.routes")
      res:
        # FIXME: this used to be possible, back when rctx.route.resource did not
        # have all SubContext instances
        data: rctx.context._data

    # TODO: generate menu from multiple sources.
    menu: ( rctx ) ->
      ( req, res ) ->

    sites: ( rctx ) ->
      res:
        fmt: path.extname(rctx.res.ref).substring 1
        data: ->
          fn = if rctx.res.path \
            then rctx.res.path else if rctx.route.spec.trim '#' \
            then rctx.route.spec else 'sites.json'
          fn = Router.expand_path fn, ctx
          srcfmt = path.extname(fn).substring 1
          libconf.load_file fn, ext: ".#{srcfmt}"

    'sites-to-menu': ( rctx ) ->
      res:
        data: ->
          fn = Router.expand_path ( if rctx.res.path \
            then rctx.res.path else rctx.route.spec ), ctx
          srcfmt = path.extname(fn).substring 1
          console.log 'sites', fn, srcfmt

          ###
          FIXME
          # TODO: access other resource context by url
          if not rctx.res.src
            rctx.res.src = URL.parse \
              rctx.site.base+rctx.route.spec.trim '#'
          deref.promise.local_or_remote rctx
          data = libconf.load_file fn, ext: ".#{srcfmt}"
          console.log 'sites', data

          nested_dicts_to_menu_outline \
            data, label: 'key()', items: 'names', href: 'base'

          p = path.join(rctx.cwd, fn)
          console.log p
          ###
          libconf.load_file fn #, ext: ".#{srcfmt}"
