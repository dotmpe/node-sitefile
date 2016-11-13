path = require 'path'
fs = require 'fs'
glob = require 'glob'
_ = require 'lodash'


builtin =

  # TODO: extend redir spec for status code
  redir: ( rctx, url=null, status=302 ) ->
    if not url
      url = rctx.base + rctx.name
    p = rctx.base + rctx.route.spec
    # 301: Moved (Permanently)
    # 302: Found
    # 303: See Other

    #rctx.context.redir status, url, p
    rctx.context.app.all url, (req, res) ->
      res.redirect p
    rctx.context.log '      ', url: url, '->', url: p

  static: ( rctx ) ->
    url = rctx.base + rctx.name
    p = path.join rctx.cwd, rctx.route.spec
    rctx.context.app.use url, rctx.context.static_proto p
    rctx.context.log 'Static', url: url, '=', path: rctx.route.spec


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
  file_res_ctx: ( ctx, init, file_path ) ->
    init.res = {
      ref: ctx.base + file_path
      path: file_path
      extname: path.extname file_path
      dirname: path.dirname file_path
    }
    init.res.basename = path.basename file_path, init.res.extname
    # Create resolver sub-context
    ctx.getSub init


  # Return resource paths
  resolve: ( route, router_name, handler_name, handler_spec, ctx ) ->

    # List for resource contexts
    rs = []

    rsctxinit =
      name: route
      route:
        name: router_name
        handler: handler_name
        spec: handler_spec
        options: if ctx.sitefile.options and router_name of ctx.sitefile.options \
          then ctx.resolve "sitefile.options.#{router_name}" else {}

    # Use exact route as fs path
    if fs.existsSync route
      rctx = Base.file_res_ctx ctx, rsctxinit, route
      rs.push rctx

    # Use route as ID for glob spec (a set of existing fs paths)
    else if route.startsWith '_'
      ctx.log 'Dynamic', url: route, '', path: handler_spec
      for name in glob.sync handler_spec
        rctx = Base.file_res_ctx ctx, rsctxinit, name
        if rctx.res.dirname == '.'
          rctx.res.ref = ctx.base + rctx.res.basename
        else
          rctx.res.ref = "#{ctx.base}#{rctx.res.dirname}/#{rctx.res.basename}"
          dirurl = ctx.base + rctx.res.dirname
          if not ctx.routes.directories.hasOwnProperty dirurl
            ctx.routes.directories[ dirurl ] = [ rctx.res.basename ]
          else
            ctx.routes.directories[ dirurl ].push rctx.res.basename
          #rctx.path = dirurl

        rs.push rctx

    else if fs.existsSync handler_spec
      rctx = Base.file_res_ctx ctx, rsctxinit, handler_spec
      rctx.res.ref = ctx.base + route
      rs.push rctx

    # Use route as is
    else
      init = res: ref: ctx.base + route
      _.defaultsDeep init, rsctxinit
      rctx = ctx.getSub init
      rs.push rctx
  
    return rs

  initialize: ( router_type, rctx ) ->

    rctx.context.routes.resources.push rctx.res.ref

    # generate: let router_type return handlers for given resource
    if rctx.route.handler of router_type
      h = router_type[rctx.route.handler] rctx
    else
      h = router_type.generate rctx

    if not h
      module.exports.warn "Router #{rctx.route.name} returned nothing for #{rctx.name}, ignored"
      return

    rctx.context.app.all rctx.res.ref, ( req, res ) ->
      _.defaultsDeep rctx.route.options, req.query
      h req, res
   

module.exports =

  builtin: builtin
  Base: Base
  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin


