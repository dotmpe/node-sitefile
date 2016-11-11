path = require 'path'
fs = require 'fs'
glob = require 'glob'
_ = require 'lodash'


builtin =

  # TODO: extend redir spec for status code
  redir: ( route, url, handler_spec, ctx, status=302 ) ->
    if not url
      url = ctx.base + route
    p = ctx.base + handler_spec
    # 301: Moved (Permanently)
    # 302: Found
    # 303: See Other
    ctx.redir status, url, p
    ctx.log '      ', url: url, '->', url: p

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


  # Return resource sub-context for local file resource
  file_res_ctx: ( rctx, file_path ) ->
    rsctx = rctx.getSub(
      ref: rctx.context.base + file_path
      path: file_path
      extname: path.extname file_path
      dirname: path.dirname file_path
      basename: null
    )
    rsctx.basename = path.basename file_path, rsctx.extname
    rsctx


  # Return resource paths
  resolve: ( route, router_name, handler_name, handler_spec, ctx ) ->

    # Create resolver sub-context
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

    # List for resource contexts
    rs = []

    # Use exact route as fs path
    if fs.existsSync route
      rsctx = Base.file_res_ctx rctx, route
      rs.push rsctx

    # Use route as ID for glob spec (a set of existing fs paths)
    else if route.startsWith '_'
      ctx.log 'Dynamic', url: route, '', path: handler_spec
      for name in glob.sync handler_spec
        rsctx = Base.file_res_ctx rctx, name
        if rsctx.dirname == '.'
          rsctx.ref = ctx.base + rsctx.basename
        else
          rsctx.ref = "#{ctx.base}#{rsctx.dirname}/#{rsctx.basename}"
          dirurl = ctx.base + rsctx.dirname
          if not ctx.routes.directories.hasOwnProperty dirurl
            ctx.routes.directories[ dirurl ] = [ rsctx.basename ]
          else
            ctx.routes.directories[ dirurl ].push rsctx.basename
          #rsctx.path = dirurl

        rs.push rsctx
        #yield rsctx

    else if fs.existsSync handler_spec
      rsctx = Base.file_res_ctx rctx, handler_spec
      rsctx.ref = ctx.base + route
      rs.push rsctx

    # Use route as is
    else # XXX
      res = if rctx.router.handler.name \
            then "#{router_name}.#{rctx.router.handler.name}" \
            else router_name
      res += ":#{rctx.router.handler.spec}(#{route})"
      rsctx = rctx.getSub(
        ref: ctx.base + route
        spec: rctx.router.handler.spec
        res: res
      )
      rs.push rsctx
  
    return rs


module.exports =
  builtin: builtin
  Base: Base

  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin

