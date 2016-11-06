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
require './util'

version = "0.0.5-dev" # node-sitefile


c =
  sc: chalk.grey ':' # sc: separator-char


builtin = [ 'redir', 'static' ]



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
    specs: {}

  sitefile


load_sitefile = ( ctx ) ->
  ctx.sitefile = get_local_sitefile ctx
  log "Loaded", path: path.relative ctx.cwd, ctx.lfn

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
      result[ key ] = value

  _.transform ctx.sitefile, xform

  if ctx.sitefile.host
    ctx.host = ctx.sitefile.host

  if ctx.sitefile.port
    ctx.port = ctx.sitefile.port


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
    ctx.config_name = 'config/config'
    # XXX config per client
    #scriptconfig = 'config/config-#{ctx.proc.name}'
    #configs = glob.sync path.join ctx.noderoot, scriptconfig + '.*'
    #if not _.isEmpty configs
    #  ctx.config_name = scriptconfig
  ctx.config_envs = require path.join ctx.noderoot, ctx.config_name
  ctx.config = ctx.config_envs[ctx.envname]
  _.defaults ctx, ctx.config
  ctx.config


prepare_context = ( ctx={} ) ->

  # Apply all static properties (set ctx.static too)
  _.merge ctx, load_rc ctx

  # Appl defaults if not present
  _.defaults ctx,
    noderoot: path.dirname path.dirname __dirname
    version: version
    cwd: process.cwd()
    proc:
      name: path.basename process.argv[1]
    envname: process.env.NODE_ENV or 'development'
    log: log
  _.defaults ctx,
    pkg_file: path.join ctx.noderoot, 'package.json'
  _.defaults ctx,
    pkg: require( ctx.pkg_file )

  if not ctx.config
    load_config ctx

  # Load local sitefile (set ctx.sitefile)
  if not ctx.sitefile?
    load_sitefile ctx

  new Context ctx



# Split sitefile router specs
split_spec = ( strspec, ctx={} ) ->
  [ handler_path, hspec ] = strspec.split(':')
  if handler_path.indexOf '.' != -1
    [ router_name, handler_name ] = handler_path.split '.'
  else
    router_name = handler_path
  [ router_name, handler_name, hspec ]


class Sitefile
  constructor: ( @ctx ) ->
    _.defaults @, dirs: {}, routers: {}, router_names: []
    # Track all dirs for generated files
    # TODO May want the same for regular routes.
    # TODO Also need to refactor, and scan for defaults across dirs rootward
    @load_routers @ctx
    # Apply routes in sitefile to Express
    @apply_routes @ctx
    # reload ctx.{config,sitefile} whenever file changes
    reload_on_change @ctx

  load_routers: ( ctx ) ->

    @router_names = _.union (
      router_name for [ router_name, handler_name, handler_spec ] in (
        split_spec strspec, ctx for route, strspec of ctx.sitefile.routes ) )
  
    log 'Required routers', name: @router_names.join ', '
  
    # parse sitefile.routes, pass 1: load & init routers
    for name in @router_names
      if name of Router.builtin
        continue

      router_cb = require './routers/' + name
      router_obj = router_cb ctx
  
      if not router_obj
        warn "Failed to load #{name}"
        continue
  
      @routers[name] =
        module: router_cb
        object: Router.define router_obj
  
      log "Loaded router", name: name, c.sc, router_obj.label

  apply_routes: ( ctx ) ->
  
    _.defaults ctx, base: '/', dir: defaults: [ 'default', 'index', 'main' ]

    # parse sitefile.routes, pass 2: process specs to handler intances
    for route, strspec of ctx.sitefile.routes

      [ router_name, handler_name, handler_spec ] = split_spec strspec, ctx
      if router_name not of Router.builtin and not @routers[ router_name ]
        warn "Skipping route", name: router_name, c.sc, path: handler_spec
        continue

      # Get router to resolve Sitefile config values to resource contexts
      if router_name of Router.builtin
        router = Router.Base
      else
        router = @routers[ router_name ].object

      ctx.dirs = @dirs
      for rsr in router.resolve route, router_name, \
          handler_name, handler_spec, ctx

        if rsr.extname and not ( rsr.ref+rsr.extname is rsr.ref )
          # FIXME: policy on extensions
          ctx.redir rsr.ref+rsr.extname, rsr.ref
          #ctx.log 'redir', rsr.ref+rsr.extname, rsr.ref

        if router_name of Router.builtin
          Router.builtin[router_name]( route, rsr.ref, handler_spec, ctx )
        else
          log route, url: rsr.ref, '=', if 'path' of rsr \
              then path: rsr.path else res: rsr.res
          # generate: let router return handlers for given resource
          h = router.generate rsr, ctx
          if h
            ctx.app.all rsr.ref, h

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
        for name in ctx.dir.defaults
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
    log "", id: ctx.sitefile.specs


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
      else if o.res?
        out.push chalk.green o.res
      else if o.path?
        out.push chalk.green o.path
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



module.exports = {
  version: version
  get_local_sitefile_name: get_local_sitefile_name
  get_local_sitefile: get_local_sitefile
  prepare_context: prepare_context
  load_config: load_config
  load_rc: load_rc
  Sitefile: Sitefile
  reload_on_change: reload_on_change
  log_enabled: true
  log: log
  warn: warn
}

