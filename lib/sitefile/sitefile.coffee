fs = require 'fs'
path = require 'path'
glob = require 'glob'
yaml = require 'js-yaml'
_ = require 'lodash'
chalk = require 'chalk'
semver = require 'semver'
nodelib = require 'nodelib'

Context = nodelib.Context

Router = require './Router'

liberror = require '../error'
libconf = require '../conf'
# register String:: exts
strutil = require '../strutil'
c = strutil.c


version = "0.0.5-dev" # node-sitefile



get_local_sitefile_name = ( ctx={} ) ->
  fn = null
  ext = null
  _.defaults ctx, basename: 'Sitefile', exts: [
    '.json'
    '.yml'
    '.yaml'
  ]
  for ext in ctx.exts
    fn = ctx.basename + ext
    if fs.existsSync fn
      ctx.fn = fn
      ctx.ext = ext
      break
    fn = null
  if not fn
    throw new Error "No #{ctx.basename}"
  ctx.lfn = path.join process.cwd(), fn
  ctx.lfn


get_local_sitefile = ( ctx={} ) ->
  lfn = get_local_sitefile_name ctx
  sitefile = libconf.load_file lfn

  sf_version = sitefile.sitefile
  if not semver.valid sf_version
    throw new Error "Not valid semver: #{sf_version}"
  if not ( semver.satisfies( ctx.version, sf_version ) or \
      semver.gt( ctx.version, sf_version ) )
    throw new Error "Version #{ctx.version} cannot satisfy "+
        "sitefile #{sf_version}"
  # TODO: validate Sitefile schema

  sitefile.path = path.relative process.cwd(), lfn

  _.defaults sitefile,
    routes: {}

  sitefile


load_sitefile = ( ctx ) ->
  ctx.sitefile = get_local_sitefile ctx


  # translate JSON path refs in sitefile to use global sitefile context
  # ie. prefix path with 'sitefile/' so we can use context.resolve et al.
  xform = (result, value, key) ->
    if _.isArray value
      for item, index in value
        xform value, item, index
    else if _.isObject value
      if value.$ref
        value.$ref = '#/sitefile' + value.$ref.substr(1)
      else
        for key, property of value
          xform value, property, key
  _.transform ctx.sitefile, xform


  # Map some sitefile attributes to root
  if ctx.sitefile.host
    ctx.site.host = ctx.sitefile.host
  if ctx.sitefile.port
    ctx.site.port = ctx.sitefile.port
  if ctx.sitefile.base
    ctx.site.base = ctx.sitefile.base

  if 'paths' of ctx.sitefile and ctx.sitefile.paths
    if 'routers' of ctx.sitefile.paths and ctx.sitefile.paths.routers

      if 'routers_replace' of ctx.sitefile.paths \
          and ctx.sitefile.paths.routers_replace
        ctx.paths.routers = ctx.sitefile.paths.routers
      else
        ctx.paths.routers = \
          ctx.paths.routers.concat ctx.sitefile.paths.routers

  log "Loaded", path: path.relative ctx.cwd, ctx.lfn


load_rc = ( ctx ) ->
  try
    ctx.static = libconf.load 'sitefilerc', get: suffixes: [ '' ], all: true
  catch error
    if error instanceof liberror.types.NoFilesException
      ctx.static = null
    else
      throw error
  ctx.static


load_config = ( ctx={} ) ->
  if not ctx.config_name?
    ctx.config_name = 'config/config.coffee'
    # XXX config per client
    #scriptconfig = 'config/config-#{ctx.proc.name}'
    #configs = glob.sync path.join ctx.noderoot, scriptconfig + '.*'
    #if not _.isEmpty configs
    #  ctx.config_name = scriptconfig

  rc = path.join '../..', ctx.config_name
  if fs.existsSync require.resolve rc
    ctx.config_envs = require rc
    ctx.config = ctx.config_envs[ctx.envname]
    _.defaultsDeep ctx, ctx.config
    if ctx.verbose
      console.log "Loaded user config for #{ctx.envname}"

  ctx.config


# Turn options dict into root context.
prepare_context = ( ctx={} ) ->

  # Apply all static properties (set ctx.static too)
  _.merge ctx, load_rc ctx

  _.defaultsDeep ctx,
    noderoot: '../../'
    version: version
    cwd: process.cwd()
    proc:
      name: path.basename process.argv[1]
    envname: process.env.NODE_ENV ? 'development'
    log: log
    verbose: false

  ctx.verbose = ctx.envname is 'development'

  _.defaultsDeep ctx,
    pkg_file: path.join ctx.noderoot, 'package.json'
  _.defaultsDeep ctx,
    pkg: require ctx.pkg_file

  load_config ctx

  _.defaultsDeep ctx,
    site:
      host: ''
      port: 8081
      base: '/'
      netpath: null
    routes:
      resources: {}
      directories: []
    bundles: {}
    paths: # TODO: configure lookup paths
      routers: [
        'sitefile:lib/sitefile/routers'
        'sitefile:var/sitefile/routers'
      ]
      bundles: [
        'sitefile:lib/sitefile/bundles'
        'sitefile:var/sitefile/bundles'
      ]


  # Load local sitefile (set ctx.sitefile)
  unless ctx.sitefile?
    load_sitefile ctx


  Context::get_auto_export = ( router_name ) ->


  # Use router setings to determine opts per request (ie. to override from
  # query)
  Context::req_opts = ( request ) ->

    options = _.merge {}, @route.options


    if 'import-query' of @route
      mq = @route['merge-query']
      if 'bool' is not typeof mq
        q = _.omitBy request.query, ( v, k ) -> k in mq
      else
        # NOTE: Merge everything from query
        q = request.query
      q = expand_obj_paths q
      _.defaultsDeep options, q


    if @route['export-query-path']
      key = @route['export-query-path']
      if not options[key]
        options[key] = @route.spec.substr 0, @route.spec.length-1 # XXX: hack hack
      options[key] = @query_path_export key, request, options[key]

    if @route['export-context']
      key = @route['export-context']
      _.defaultsDeep options, expand_obj_paths "#{key}": @

    return options


  # If query key given use as rctx.res.path
  Context::query_path_export = ( key, req, defpath ) ->
    # Assert rctx.res.path isset
    if defpath
      unless @res.path
        @res.path = defpath

    if not @res.path
      throw new Error \
        "A path is required either provided by query or option '#{key}'"

    if req.query?[key]
      @res.path = req.query[key]
    else
      req.query[key] = @res.path
    if not @res.path
      throw new Error \
        "A path is required either provided by query or option '#{key}'"

    # Resolve to existing path
    return Router.expand_path @res.path, @


  if ctx.verbose
    console.log "Creating new context for #{ctx.envname}"
  new Context ctx


# Split sitefile router specs
split_spec = ( strspec, ctx={} ) ->
  idx = strspec.indexOf ':'
  handler_path = strspec.substr 0, idx
  hspec = strspec.substr idx+1
  if handler_path.indexOf '.' != -1
    [ router_name, handler_name ] = handler_path.split '.'
  else
    router_name = handler_path
  [ router_name, handler_name, hspec ]


expand_obj_paths = ( obj, toObj={} ) ->
  curObj = toObj
  for key of obj
    k = key.split '.'
    while k.length
      e = k.shift()
      if k.length
        if e not of curObj
          curObj[e] = {}
        curObj = curObj[e]
      else
        curObj[e] = obj[key]
  toObj


class Routers
  constructor: ( @ctx ) ->
    # XXX:
    if @ctx._routers then throw new Error "_routers"
    @ctx._routers = @
    @data = {}

  get: ( name ) ->
    if name not of @data
      throw new Error "No such router loaded: #{name}"
    return @data[ name ].object

  generator: ( name, rctx=null, ctx=null ) ->
    if name.startsWith '.'
      handler = name.substr 1
      name = rctx.route.name
    else if -1 != name.indexOf '.'
      [ name, handler ] = name.split '.'
    else
      handler = 'default'

    if name not of @data
      throw new Error "No router for #{name}"
    if not handler or \
        handler not of @data[name].object.generate
      throw new Error "No router generate handler #{handler} for #{name}"

    @data[ name ].object.generate[ handler ]

  find: ( name ) ->
    router_cb = null
    rip = null
    for rip in @ctx.paths.routers
      p = rip
      if p.startsWith 'sitefile:'
        p = path.join @ctx.sfdir, p.substr 9
      if not p.startsWith '/'
        p = path.join process.env.PWD, p
      try
        router_cb = require path.join p, name
        break
      catch err
        continue
    [ router_cb, rip ]

  # Pre-load routers
  load: ->

    @names = _.union (
      router_name for [ router_name, handler_name, handler_spec ] in (
        split_spec strspec, @ctx for route, strspec of @ctx.sitefile.routes ) )

    log 'Required routers', name: @names.join ', '

    # parse sitefile.routes, pass 1: load & init routers
    for name in @names
      if name of Router.builtin
        continue

      [ router_cb, router_path ] = @find name
      if not router_cb
        warn "Failed to load #{name} router"
        continue

      router_obj = router_cb @ctx
      if not router_obj
        warn "Failed to initialize #{name} router"
        continue

      @data[name] =
        module: router_cb
        object: Router.define router_obj

      log "Loaded router", name: name, c.sc, router_obj.label, path: router_path


class Sitefile
  constructor: ( @ctx ) ->
    # Track all dirs for generated files, router CB's and instances, names
    _.defaults @, dirs: {}, bundles: {}
    # XXX:
    if @ctx._sitefile then throw new Error "_sitefile"
    @ctx._sitefile = @
    # TODO Also need to refactor, and scan for defaults across dirs rootward
    @routers = new Routers @ctx
    @routers.load()
    # Load predefined resources (views, scripts, styles etc. w/ route maps)
    @load_bundles @ctx
    # Apply routes in sitefile to Express
    @apply_routes @ctx
    # reload ctx.{config,sitefile} whenever file changes
    reload_on_change @ctx

  # Preload other, non router bundles
  load_bundles: ( ctx ) ->
    for bundle of ctx.sitefile.bundles
      if typeof(bundle) == 'string'
        # Try importing, otherwise keep as name for something loaded at a later
        # time
        bundle_name = bundle
        bundle_obj = name: bundle_name
      else if typeof(bundle) == 'object'
        # Use in-sitefile defined bundle
        bundle_name = bundle.name
        bundle_obj = bundle
      @bundles[ bundle_name ] = bundle_obj
      

  apply_routes: ( ctx ) ->
  
    options = {
      routes:
        resources: {}
        directories: {}
        defaults: [ 'default', 'index', 'main' ]
    }
    ctx.prepare_from_obj options
    ctx.seed options

    # parse sitefile.routes, pass 2: process specs to handler intances
    for route, strspec of ctx.sitefile.routes

      # Skip route spec on missing routers
      [ router_name, handler_name, handler_spec ] = split_spec strspec, ctx

      if router_name not of Router.builtin and router_name not in @routers.names
        warn "Skipping route", name: router_name, c.sc, path: handler_spec
        continue

      if route.startsWith '/' or route.startsWith ctx.site.base
        warn "Non-relative route", "Route path should not include root '/' or
          base prefix, are you sure #{route} is correct?"

      # Get merged router_type definition
      if router_name of Router.builtin
        router_type = Router.Base
      else
        if router_name not of @routers.data
          warn "Missing router #{router_name}"
          continue
        router_type = @routers.get router_name

      # Get generate handler name
      if not handler_name
        handler_name = if router_type.defaults?.handler? \
          then router_type.defaults.handler else 'default'

      # XXX: hooking Sitefile dirlist into ctx
      ctx.routes.directories = @dirs

      # Resolve route spec to resource contexts with sitefile settings
      for rctx in router_type.resolve route, router_name, \
          handler_name, handler_spec, ctx

        # Merge router local defaults onto global sitefile context.

        # Then update rctx.route with local and global sitefile and router defaults.

        if router_type.defaults?
          # Add global and local router context defaults now. 
          if router_type.defaults.global?
            if handler_name of router_type.defaults.global
              _.defaultsDeep rctx.route, \
                router_type.defaults.global[ handler_name ]
          if router_type.defaults.local?
            if route of router_type.defaults.local
              _.defaultsDeep rctx.route, \
                router_type.defaults.local[ handler_name ]

        # Detect routable extension
        rs = rctx.res
        if rs.path and (ctx.site.base+rs.path).startsWith(rs.ref) and (
          rs.ref+rs.extname is ctx.site.base+rs.path
        )
          # FIXME: policy on extensions
          ctx.redir rs.ref+rs.extname, rs.ref
          #ctx.log 'redir', rs.ref+rs.extname, rs.ref

        # Finally let routers generate or add routes to ctx.app Express instance
        if router_name of Router.builtin
          Router.builtin[router_name] rctx

        else
          router_type.initialize router_type, rctx


    # redirect dirs to default dir-index resource
    @add_dir_redirs ctx
  
  # For each given dir-name: leafs pair,
  # add a redir rule to redirect to a dir leaf
  add_dir_redirs: ( ctx ) ->
    # Add redirections for dirs to default leafs
    for url, leafs of @dirs
      if leafs.length == 1
        defleaf = leafs[0]
      if leafs
        for name in ctx.routes.defaults
          if name in leafs
            defleaf = name
            break
        if not defleaf
          warn "Cannot choose default dir index for #{url}"
          continue
        ctx.redir url, url+'/'+defleaf
        log "Dir", url: "#{url}/{->#{defleaf}}"



# XXX only reloads on src file or sitefile change
# XXX does not reload routes, code+config only
# TODO should reload sitefilerc, should reset/apply routes
reload_on_change = ( ctx ) ->
  config_watch = ctx.noderoot + '/config/**/*'
  paths = expand_globs [ config_watch ]
  log 'Watching configs', path: paths.join ', '
  for fn in paths
    fs.watchFile fn, ( cur, prev ) ->
      log "Reloading config", "because: #{fn} changed"
      load_config ctx

  log 'Watching sitefile', path: ctx.lfn
  fs.watchFile ctx.lfn, ( cur, prev ) ->
    log "Reloading context", "because: #{ctx.lfn} changed"
    load_sitefile ctx


expand_globs = ( patterns ) ->
  _.flattenDeep [ glob.sync p for p, i in patterns ]



warn = ->
  v = Array.prototype.slice.call( arguments )
  out = [ chalk.red(v.shift()) + c.sc ]
  console.warn.apply null, log_line( v, out )

log = ->
  if module.exports.log_enabled
    v = Array.prototype.slice.call( arguments )
    header = _.padStart v.shift(), 21
    out = [ chalk.blue(header) + c.sc ]
    console.log.apply null, log_line( v, out )

log_line = ( v, out=[] ) ->
  while v.length
    o = v.shift()
    if o?
      if _.isString o
        if o.match /^[\<\>_:-]+$/
          out.push chalk.grey o
        else if o.match /[\<\>=_]+/
          out.push chalk.magenta o
        else
          out.push o
      else if o.res? or o.format? or o.path?
        out.push chalk.green o.res or o.format or o.path
      else if o.url?
        out.push chalk.yellow o.url
      else if o.name?
        out.push chalk.cyan o.name
      else if o.id?
        out.push chalk.magenta o.id
      else
        throw new Error "log: unhandled " + JSON.stringify o
    else
      out.push JSON.stringify o
  out



Router.log = log
Router.warn = warn


module.exports =
  {
    version: version
    get_local_sitefile_name: get_local_sitefile_name
    get_local_sitefile: get_local_sitefile
    prepare_context: prepare_context
    load_config: load_config
    load_rc: load_rc
    Router: Router,
    Sitefile: Sitefile
    reload_on_change: reload_on_change
    log_enabled: true
    log: log
    warn: warn
  }


