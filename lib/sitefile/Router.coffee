path = require 'path'
fs = require 'fs'
glob = require 'glob'
_ = require 'lodash'


builtin =

  redir: ( route, url, handler_spec, ctx ) ->
    if not url
      url = ctx.base + route
    p = ctx.base + handler_spec
    ctx.redir url, p
    ctx.log '     *', url: url, '->', url: p

  static: ( route, url, handler_spec, ctx ) ->
    # FIXME: if not url
    url = ctx.base + route
    p = path.join ctx.cwd, handler_spec
    ctx.app.use url, ctx.static_proto p
    ctx.log 'Static', url: url, '=', path: handler_spec


Base =
  name: 'Express'
  label: 'Express-Sitefile resource publisher'
  usage: """
  
    Static path
      /path: <router[.handler-generator]>:<handler-spec>

    Leading underscore (accepts file glob handler-spec)
      _route_id: <router[.handler-generator]>:<handler-spec>
  
  TODO: maybe, later:
  
    Dollar path.
      /data/$record: <router[.handler-generator]>:<handler-spec>

    Prefix path
      /prefix$: <router[.handler-generator]>:<handler-spec>

  
  Also: handler-spec vs. glob-spec. Routers should parse own args.

  Router.Base provide some standard resolvers:

  - path/to/file-name.ext1.ext2
  - path/to/dir

  """

  #parse_spec: ( route_spec, handler_spec, ctx ) ->

  # process parametrized rule
  #else if '$' in route
  #  url = ctx.base + route.replace('$', ':')
  #  log route, url: url
  #  app.all url, handler.generator '.'+url, ctx

  # Return handler for path
  generate: ( url_path, ctx ) ->
  # XXX:
  handler: ( url_path ) ->
  register: ( app, ctx ) ->

  # Return resource paths
  resolve: ( route, handler_name, handler_spec, ctx ) ->
    rctx = ctx.getSub(
      #route:
      name: route
      #strspec: strspec
      router:
        #name: router_name
        handler:
          name: handler_name
          spec: handler_spec
    )

    rs = []

    # Use exact route as fs path
    if fs.existsSync route
      sctx = rctx.getSub(
        ref: ctx.base + route
        path: route
      )
      rs.push sctx

    # Use route as ID for glob spec (a set of existing fs paths)
    else if route.startsWith '_'
      ctx.log 'Dynamic', url: route, '', path: handler_spec

      for name in glob.sync handler_spec
        sctx = rctx.getSub(
          ref: null
          path: name
          extname: path.extname name
          dirname: path.dirname name
          basename: null
        )
        sctx.basename = path.basename name, sctx.extname
        if sctx.dirname == '.'
          sctx.ref = ctx.base + sctx.basename
          #sctx.path = ctx.base
        else
          sctx.ref = "#{ctx.base}#{sctx.dirname}/#{sctx.basename}"
          dirurl = ctx.base + sctx.dirname
          if not ctx.dirs.hasOwnProperty dirurl
            ctx.dirs[ dirurl ] = [ sctx.basename ]
          else
            ctx.dirs[ dirurl ].push sctx.basename
          #sctx.path = dirurl

        rs.push sctx
        #yield sctx

    # Use route as is
    else # XXX
      sctx = rctx.getSub(
        ref: ctx.base + route
        res: route
      )
      rs.push sctx
  
    return rs


module.exports =
  builtin: builtin
  Base: Base

  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin

