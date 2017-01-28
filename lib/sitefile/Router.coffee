path = require 'path'
fs = require 'fs'
minimatch = require 'minimatch'
glob = require 'glob'
_ = require 'lodash'

libconf = require '../conf'
nodelib = require 'nodelib-mpe'
Context = nodelib.Context



expand_paths_spec_to_route = ( rctx ) ->
  spec = rctx.route.spec
  if spec and '#' != spec
    # Expand non-glob from spec to paths
    srcs = minimatch.braceExpand spec
  else
    # Or fall back to verbatim route name as path
    srcs = [ rctx.name ]
  for src, idx in srcs
    srcs[idx] = libconf.expand_path src, rctx
  return srcs


# Load default options from Sitefile
resolve_route_options = ( ctx, route, router_name ) ->
  opts = {}

  if 'options' of ctx.sitefile

    # Global sitefile options (per router)
    if ctx.sitefile.options.global and router_name
      if router_name of ctx.sitefile.options.global
        global_opts = null
        #ctx.get "sitefile.options.global.#{router_name}"
        try
          global_opts = ctx.resolve "sitefile.options.global.#{router_name}"
        catch error
          null
        if global_opts
          opts = _.defaults {}, global_opts, opts

    # Local (per route) sitefile options
    if ctx.sitefile.options.local and route
      if route of ctx.sitefile.options.local
        local_opts = null
        esc = route.replace '.', '\\.'
        try
          local_opts = ctx.resolve "sitefile.options.local.#{esc}"
        catch error
          null
        if local_opts
          opts = _.defaultsDeep {}, local_opts, opts

  opts


builtin =


  # TODO: extend redir spec for status code
  redir: ( rctx, url=null, status=302 ) ->
    if not url
      url = rctx.base() + rctx.name
    p = rctx.base() + rctx.route.spec

    # 301: Moved (Permanently)
    # 302: Found
    # 303: See Other

    rctx.context.log 'redir', url, p

    if rctx.route.handler == 'temp'
      rctx.context.redir 302, url, p
    else if rctx.route.handler == 'perm'
      rctx.context.redir 301, url, p
    else
      #rctx.context.redir status, url, p
      rctx.context.app.all url, ( req, res ) ->
        res.redirect p

    rctx.context.log '      ', url: url, '->', url: p


  static: ( rctx ) ->

    url = rctx.res.ref

    srcs = expand_paths_spec_to_route rctx

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
  #  url = ctx.base() + route.replace('$', ':')
  #  log route, url: url
  #  app.all url, handler.generator '.'+url, ctx

  # Return handler for path
  generate: ( ctx ) ->
  # XXX:
  register: ( app, ctx ) ->

  # Return resource sub-context for local file resource
  file_res_ctx: ( ctx, init, file_path ) ->
    init.res = {
      ref: ctx.base() + file_path
      path: file_path
      extname: path.extname file_path
      dirname: path.dirname file_path
    }
    init.res.basename = path.basename file_path, init.res.extname
    # Create resolver sub-context
    ctx.getSub init

  prepare_dyn_path_res: ( rctx, ctx ) ->
    if rctx.res.dirname == '.'
      rctx.res.ref = ctx.base() + rctx.res.basename
    else
      rctx.res.ref = \
        "#{ctx.base()}#{rctx.res.dirname}/#{rctx.res.basename}"
      dirurl = ctx.base() + rctx.res.dirname
      # XXX: dir tracking 
      if not ctx.routes.directories.hasOwnProperty dirurl
        ctx.routes.directories[ dirurl ] = [ rctx.res.basename ]
      else
        ctx.routes.directories[ dirurl ].push rctx.res.basename
      #rctx.path = dirurl

  default_resource_options: ( rctx, ctx, updateRef=false ) ->
    router = rctx.route.name
    if updateRef
      if 'string' is typeof updateRef
        rctx.res.ref = updateRef
      else
        Base.prepare_dyn_path_res rctx, ctx
    # Now parse dynamic path back from ref  and look for defaults
    route = rctx.res.ref.substr ctx.base().length
    rctx.route.options = resolve_route_options( ctx, route, router )

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

    # Route is RegEx
    if route.startsWith 'r:'
      init = res:
        ref: ctx.base() + route.substr 2
        match: new RegExp route.substr 2
      _.defaultsDeep init, rsctxinit
      rctx = ctx.getSub init
      Base.default_resource_options rctx, ctx
      rs.push rctx

    # Use exact route as fs path
    else if fs.existsSync route
      rctx = Base.file_res_ctx ctx, rsctxinit, route
      Base.default_resource_options rctx, ctx
      rs.push rctx

    # Use route as ID for glob spec (a set of existing fs paths)
    else if route.startsWith '_'
      ctx.log 'Dynamic', url: route, '', path: handler_spec
      for name in glob.sync handler_spec
        rctx = Base.file_res_ctx ctx, rsctxinit, name
        Base.default_resource_options rctx, ctx, true
        rs.push rctx

    else if fs.existsSync handler_spec
      rctx = Base.file_res_ctx ctx, rsctxinit, handler_spec
      Base.default_resource_options rctx, ctx, ctx.base() + route
      rs.push rctx

    # Use route as is
    else
      init = res: ref: ctx.base() + route
      _.defaultsDeep init, rsctxinit
      rctx = ctx.getSub init
      Base.default_resource_options rctx, ctx
      rs.push rctx
  
    return rs

  initialize: ( router_type, rctx ) ->

    ctx = rctx.context

    # routes.resources: Track all paths to router instances
    ctx.routes.resources[rctx.res.ref] = rctx

    # generate: let router_type return handlers for given resource

    if rctx.route.handler
      g = ctx._routers.generator '.'+rctx.route.handler, rctx
    else
      g = ctx._routers.generator rctx.route.name

    # invoke routers selected generate function, expect a route handler object
    h = g rctx

    ref = if rctx.res.match then rctx.res.match else rctx.res.ref

    if 'function' is typeof h

      # Add as regular Express route handler
      rctx.context.app.all ref, ( req, res ) ->
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
        rctx.context.app.all ref, builtin.data rctx

      ctx.log "Extension at ", url: rctx.res.ref, \
          "from", ( name: rctx.route.name+'.'+rctx.route.handler ), \
          id: rctx.route.spec, "at", path: rctx.name

    else if not h
      module.exports.warn "Router not recognized", "Router
        #{rctx.route.name}.#{rctx.route.handler}
        returned nothing recognizable at #{rctx.name}, ignored"
    

module.exports =

  builtin: builtin

  Base: Base

  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin

  resolve_route_options: resolve_route_options

  # XXX: spec parse helper
  expand_paths_spec_to_route: expand_paths_spec_to_route

  # XXX: spec parse helper
  parse_kw_spec: ( rctx ) ->
    kw = {}
    specs = rctx.route.spec.split ';'
    for spec in specs
      x = spec.indexOf '='
      k = spec.substr(0, x)
      kw[k] = spec.substr x+1
    kw

