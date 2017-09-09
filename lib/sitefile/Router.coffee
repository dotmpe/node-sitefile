path = require 'path'
fs = require 'fs'
minimatch = require 'minimatch'
glob = require 'glob'
_ = require 'lodash'

nodelib = require 'nodelib-mpe'
Context = nodelib.Context
yaml = require 'js-yaml'
Promise = require 'bluebird'


expand_path = ( src, ctx ) ->
  base = ctx.sfdir+'/'
  if src.startsWith 'sitefile:'
    return src.replace 'sitefile:', base
  libdir = base+'lib/sitefile/'
  if src.startsWith 'sitefile-lib:'
    return src.replace 'sitefile-lib:', libdir
  if src.startsWith 'sitefile-client:'
    return src.replace 'sitefile-client:', libdir+'client/'
  src


expand_paths_spec_to_route = ( rctx ) ->
  spec = rctx.route.spec
  if spec and '#' != spec
    # Expand non-glob from spec to paths
    srcs = minimatch.braceExpand spec
  else
    # Or fall back to verbatim route name as path
    srcs = [ rctx.name ]
  # Now expand prefixes
  for src, idx in srcs
    srcs[idx] = expand_path src, rctx
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


# Wrap rctx with data resource in promise
promise_resource_data = ( rctx ) ->
  ctx = rctx.context
  name = "generator '#{rctx.route.name}.#{rctx.route.handler}'"
  if "function" is typeof rctx.res.data.then
    ctx.debug "Router #{name} returned data-promise for '#{rctx.res.ref}'"
    rctx.res.data
  else
    ctx.debug "Constructing #{name} data-promise handler for '#{rctx.res.ref}'"
    new Promise ( resolve, reject ) ->
      ctx.debug "Running #{name} data-promise handler for '#{rctx.res.ref}'"
      data = rctx.res.data
      r = 0
      while "function" is typeof data
        if r == rctx.config['data-resolve-limit']
          throw new Error "data-resolve-limit #{r}"
        data = data()
        r += 1
      resolve data


builtin =


  # TODO: extend redir spec for status code
  redir: ( rctx, url=null, status=302, tourl=null ) ->
    if not url
      url = rctx.site.base + rctx.name
    if not tourl
      tourl = rctx.site.base + rctx.route.spec

    # 301: Moved (Permanently)
    # 302: Found
    # 303: See Other

    #rctx.context.debug 'redir', url, tourl

    if rctx.route.handler == 'temp'
      rctx.context.redir 302, url, tourl
    else if rctx.route.handler == 'perm'
      rctx.context.redir 301, url, tourl
    else
      #rctx.context.redir status, url, tourl
      rctx.context.app.all url, ( req, res ) ->
        res.redirect tourl

    #rctx.context.debug '      ', url: url, '->', url: tourl


  static: ( rctx ) ->

    url = rctx.res.ref
    srcs = expand_paths_spec_to_route rctx

    rctx.context.app.use url, [
      rctx.context.static_proto src for src in srcs
    ]

    #rctx.debug 'Static', url: url, '=', path: rctx.route.spec


  # Take care of rendering from a rctx with data, for a (data) handler that does
  # not care too itself since it is a very common task.
  data: ( rctx ) ->
    name = "generator '#{rctx.route.name}.#{rctx.route.handler}'"
    rctx.debug \
    "Primed built-in Route.data handler for #{name} to '#{rctx.res.ref}'"
    ( req, res ) ->
      rctx.debug \
      "Running built-in Route.data handler for #{name} to '#{rctx.res.ref}'"
      writer = if rctx.res.fmt? then rctx.res.fmt else 'json'
      deferred = promise_resource_data rctx
      deferred
      .catch ( err ) ->
        res.status 500
        res.write err
        res.end
      .then ( data ) ->
        if writer == 'json'
          rctx.debug 'dumping json'
          output = JSON.stringify data
        else if writer in ['yaml', 'yml']
          rctx.debug 'dumping yaml'
          output = yaml.safeDump data
        else
          throw new Error "No writer #{writer}"
        res.type writer
        res.write output
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

  prepare_dyn_path_res: ( rctx, ctx ) ->
    if rctx.res.dirname == '.'
      rctx.res.ref = ctx.site.base + rctx.res.basename
    else
      rctx.res.ref = \
        "#{ctx.site.base}#{rctx.res.dirname}/#{rctx.res.basename}"
      dirurl = ctx.site.base + rctx.res.dirname
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
    route = rctx.res.ref.substr ctx.site.base.length
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
        ref: ctx.site.base + route.substr 2
        rx: new RegExp route.substr 2
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
      # DEBUG: ctx.log 'Dynamic', url: route, '', path: handler_spec
      for name in glob.sync handler_spec
        rctx = Base.file_res_ctx ctx, rsctxinit, name
        Base.default_resource_options rctx, ctx, true
        rs.push rctx

    else if fs.existsSync handler_spec
      rctx = Base.file_res_ctx ctx, rsctxinit, handler_spec
      Base.default_resource_options rctx, ctx, ctx.site.base + route
      rs.push rctx

    # Use route as is
    else
      init = res: ref: ctx.site.base + route
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

    ref = if rctx.res.rx? then rctx.res.rx else rctx.res.ref

    if 'function' is typeof h

      # Add as regular Express route handler
      rctx.context.app.all ref, ( req, res ) ->
        _.defaultsDeep rctx.route.options, req.query
        h req, res

      # DEBUG:
      #ctx.log rctx.name, url: rctx.res.ref, '=', ( if 'path' of rctx.res \
      #  then path: rctx.res.path \
      #  else res: rctx.route.name ), id: rctx.route.spec

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
      module.exports.warn "Router not recognized", "Router #{rctx.route.name}
        returned nothing recognizable for #{rctx.name}, ignored"
    

module.exports =

  builtin: builtin

  Base: Base

  # Current way of 'instantiating' router
  define: ( mixin ) ->
    _.assign {}, Base, mixin

  resolve_route_options: resolve_route_options

  # XXX: spec parse helper
  expand_paths_spec_to_route: expand_paths_spec_to_route
  expand_path: expand_path

  # XXX: spec parse helper
  parse_kw_spec: ( rctx ) ->
    kw = {}
    specs = rctx.route.spec.trim('#').split ';'
    for spec in specs
      x = spec.indexOf '='
      k = spec.substr(0, x)
      kw[k] = spec.substr x+1
    kw

  # XXX: Read JSON + jspath
  read_xref: ( ctx, spec ) ->
    if '#' not in spec
      throw new Error spec
    [ jsonf, spec ] = spec.split '#'
    jsonf = expand_path jsonf, ctx
    if not jsonf.startsWith path.sep
      jsonf = path.join ctx.cwd, jsonf
    p = spec.split '/'
    if not p[0]
      p.shift()
    o = require jsonf
    c = o
    while p.length
      e = p.shift()
      c = c[e]
    return c

