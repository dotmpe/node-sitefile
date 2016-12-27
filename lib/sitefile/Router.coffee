path = require 'path'
fs = require 'fs'
minimatch = require 'minimatch'
glob = require 'glob'
_ = require 'lodash'



expand_path_spec_to_route = ( rctx ) ->
  spec = rctx.route.spec
  console.log 'spec', spec
  if spec and '#' != spec
    # Expand non-glob from spec to paths
    srcs = minimatch.braceExpand spec
  else
    # Or fall back to verbatim route name as path
    srcs = [ rctx.name ]
  for src, idx in srcs
    if src.startsWith 'sitefile:'
      srcs[idx] = src.replace 'sitefile:', rctx.sfdir+path.sep
  return srcs


builtin =

  # TODO: extend redir spec for status code
  redir: ( rctx, url=null, status=302 ) ->
    if not url
      url = rctx.site.base + rctx.name
    p = rctx.site.base + rctx.route.spec
    # 301: Moved (Permanently)
    # 302: Found
    # 303: See Other

    #rctx.context.redir status, url, p
    rctx.context.app.all url, ( req, res ) ->
      res.redirect p
    rctx.context.log '      ', url: url, '->', url: p

  static: ( rctx ) ->

    url = rctx.res.ref

    srcs = expand_path_spec_to_route rctx

    rctx.context.app.use url, [
      rctx.context.static_proto src for src in srcs
    ]

    rctx.context.log 'Static', url: url, '=', path: rctx.route.spec


  # Take care of rendering from a rctx with data, for a (data) handler that does
  # not care too itself since it is a very common task.
  data: ( rctx ) ->
    ( req, res ) ->
      res.type 'json'
      res.write JSON.stringify \
        if "function" is typeof rctx.res.data
        then rctx.res.data()
        else rctx.res.data
      res.end()

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

  # TODO: resource types? to use as 'backend' for fe route handlers..
  resources:
    'core.sitefile': null # Sitefile instance?
    'core.sitefilerc': null # Subset mapped to ctx
    'core.sitefile.extension': null # JS or coffee file
    'core.sitefile.route.autocomplete': null # jQuery autcomplete API
    'core.sitefile.route': null # Dynamic routes API?


  # XXX: clean me up, route spec parsing
  #parse_spec: ( route_spec, handler_spec, ctx ) ->

  # process parametrized rule
  #else if '$' in route
  #  url = ctx.site.base + route.replace('$', ':')
  #  log route, url: url
  #  app.all url, handler.generator '.'+url, ctx

  # Return handler for path
  generate: ( ctx ) ->
  # XXX:
  register: ( app, ctx ) ->

  # Return resource sub-context for local file resource
  file_res_ctx: ( ctx, init, file_path ) ->
    init.res = {
      ref: ctx.site.base + file_path
      path: file_path
      extname: path.extname file_path
      dirname: path.dirname file_path
    }
    init.res.basename = path.basename file_path, init.res.extname
    # Create resolver sub-context
    ctx.getSub init

  default_resource_options: ( rctx ) ->
    ctx = rctx.context
    if ctx.sitefile.options and ctx.sitefile.options.local \
    and rctx.name of ctx.sitefile.options.local
      _.defaultsDeep rctx._data.route.options,
        ctx.sitefile.options.local[rctx.name]
      # XXX: ctx.resolve "sitefile.options.local.#{rctx.name}"

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
        options: if 'options' of ctx.sitefile \
          and ctx.sitefile.options.global and router_name \
          of ctx.sitefile.options.global \
          then ctx.resolve "sitefile.options.global.#{router_name}" else {}

    # Use exact route as fs path
    if fs.existsSync route
      rctx = Base.file_res_ctx ctx, rsctxinit, route
      Base.default_resource_options rctx
      rs.push rctx

    # Use route as ID for glob spec (a set of existing fs paths)
    else if route.startsWith '_'
      ctx.log 'Dynamic', url: route, '', path: handler_spec
      for name in glob.sync handler_spec
        rctx = Base.file_res_ctx ctx, rsctxinit, name
        Base.default_resource_options rctx
        if rctx.res.dirname == '.'
          rctx.res.ref = ctx.site.base + rctx.res.basename
        else
          rctx.res.ref = \
            "#{ctx.site.base}#{rctx.res.dirname}/#{rctx.res.basename}"
          dirurl = ctx.site.base + rctx.res.dirname
          if not ctx.routes.directories.hasOwnProperty dirurl
            ctx.routes.directories[ dirurl ] = [ rctx.res.basename ]
          else
            ctx.routes.directories[ dirurl ].push rctx.res.basename
          #rctx.path = dirurl

        rs.push rctx

    else if fs.existsSync handler_spec
      rctx = Base.file_res_ctx ctx, rsctxinit, handler_spec
      Base.default_resource_options rctx
      rctx.res.ref = ctx.site.base + route
      rs.push rctx

    # Use route as is
    else
      init = res: ref: ctx.site.base + route
      _.defaultsDeep init, rsctxinit
      rctx = ctx.getSub init
      Base.default_resource_options rctx
      rs.push rctx
  
    return rs

  initialize: ( router_type, rctx ) ->

    ctx = rctx.context

    # routes.resources: Track all paths to router instances
    ctx.routes.resources.push rctx.res.ref

    # generate: let router_type return handlers for given resource

    if rctx.route.handler
      g = ctx._routers.generator '.'+rctx.route.handler, rctx
    else
      g = ctx._routers.generator rctx.route.name

    # invoke routers selected generate function, expect a route handler object
    h = g rctx

    if 'function' is typeof h

      # Add as regular Express route handler
      rctx.context.app.all rctx.res.ref, ( req, res ) ->
        _.defaultsDeep rctx.route.options, req.query
        h req, res

      ctx.log rctx.name, url: rctx.res.ref, '=', ( if 'path' of rctx.res \
        then path: rctx.res.path \
        else res: rctx.route.name ), id: rctx.route.spec

    else if h and 'object' is typeof h
  
      # XXX: The object could have data, meta etc. attr and play as JSON API doc
      # For now just extend the resource context with the object it returned.
      rctx.prepare_from_obj h
      _.merge rctx._data, h

      if h.res and 'data' of h.res
        rctx.context.app.all rctx.res.ref, builtin.data rctx
      
      ctx.log "Extension at ", url: rctx.res.ref, \
          "from", ( name: rctx.route.name+'.'+rctx.route.handler ), \
          id: rctx.route.spec, "at", path: rctx.name

    else if not h
      module.exports.warn "Router not recognized", "Router #{rctx.route.name}
        returned nothing recognizable for #{rctx.name}, ignored"
    

module.exports =

  builtin: builtin
  Base: Base
  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin


