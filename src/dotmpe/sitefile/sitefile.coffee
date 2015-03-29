fs = require 'fs'
path = require 'path'
glob = require 'glob'
yaml = require 'js-yaml'
_ = require 'lodash'

String::startsWith ?= (s) -> @[...s.length] is s
String::endsWith   ?= (s) -> s is '' or @[-s.length..] is s


get_local_sitefile_name = ( ctx={} )->
	# TODO: read ctx from .sitefilerc
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
		throw "No "+ctx.basename
	ctx.lfn = path.join process.cwd(), fn
	ctx.lfn

get_local_sitefile = ( ctx={} )->
	lfn = get_local_sitefile_name(ctx)
	if ctx.ext == '.json'
		sitefile = require lfn
	else if ctx.ext in [ '.yaml', '.yml' ]
		sitefile = yaml.safeLoad fs.readFileSync lfn, 'utf8'
	_.defaults sitefile, 
		routes: {}
		specs: {}
	sitefile

load_sitefile = ( ctx )->
	ctx.sitefile = get_local_sitefile ctx

prepare_context = ( ctx={} )->
	_.defaults ctx,
		noderoot: path.dirname path.dirname path.dirname __dirname
		cwd: process.cwd()
		proc: 
			name: path.basename process.argv[1]
		envname: process.env.NODE_ENV or 'development'
	if not ctx.sitefile?
		load_sitefile ctx
	ctx

load_config = ( ctx={} )->
	if not ctx.config_name?
		ctx.config_name = 'config/config'
		# XXX config per client
		#scriptconfig = 'config/config-#{ctx.proc.name}'
		#configs = glob.sync path.join ctx.noderoot, scriptconfig + '.*'
		#if not _.isEmpty configs
		#	ctx.config_name = scriptconfig
	ctx.config_envs = require path.join ctx.noderoot, ctx.config_name
	ctx.config = ctx.config_envs[ctx.envname]
	ctx.config


# Express redir handler
redir = ( app, ref, p )->
	app.all ref, (req, res)->
		res.redirect p


# Split sitefile router specs
parse_spec = ( strspec, ctx={} )->
	[ handler_path, hspec ] = strspec.split(':')
	if handler_path.indexOf '.' != -1
		[ router_name, handler_name ] = handler_path.split '.'
	else
		router_name = handler_path
	[ router_name, handler_name, hspec ]


# Apply routes in sitefile to Express
apply_routes = ( sitefile, app, ctx={} )->

	_.defaults ctx, base: '/'

	if not _.isEmpty sitefile.routes

		# Track all dirs for generated files
		# TODO May want the same for regular routes. Also need to refactor, and scan for defaults across dirs rootward
		dirs = {}

		for route, strspec of sitefile.routes

			[ router_name, handler_name, handler_spec ] = parse_spec strspec, ctx

			if route.startsWith '$'
				# add generated routes, track dirs/leafs
				if router_name not in _.keys ctx.routers
					throw "No such router: #{router_name}"
				router = ctx.routers[ router_name ].object
				if not handler_name
					handler_name = router.default
				handler = router.generate[ handler_name ]
				console.log 'Dynamic:', route, router_name, handler_name, handler_spec
				for name in glob.sync handler_spec
					basename = path.basename name, '.rst' # FIXME hardcoded rst; need file type here
					dirname = path.dirname name
					if dirname == '.'
						url = '/'+basename # FIXME route.replace('$name')
					else
						url = '/'+dirname+'/'+basename # FIXME route.replace('$name')
						if not dirs.hasOwnProperty '/'+dirname
							dirs[ '/'+dirname ] = [ basename ]
						else
							dirs[ '/'+dirname ].push basename
					console.log 'Adding', url, name
					redir app, url+'.rst', url # XXX hardcoded rst
					app.all url, handler '.'+url

			else
				# add route for single resource or redirection
				url = ctx.base + route

				# static and redir are built-in
				if router_name == 'redir'
					p = '/'+strspec.substr 6
					redir app, url, p
					console.log '       :', url, '->', p

				else if router_name == 'static'
					p = path.join ctx.cwd, handler_spec
					app.use url, ctx.static_proto p
					console.log ' Static:', url, p

				else
					# use another router to generate handler for resource
					if router_name not in _.keys ctx.routers
						throw "No such router: #{router_name}"
					router = ctx.routers[ router_name ].object
					if not handler_name
						handler_name = router.default
					handler = router.generate[ handler_name ]
					console.log "    all: #{url}, #{router_name}.#{handler_name} '#{handler_spec}'"
					app.all url, handler handler_spec

		# Add redirections for dirs to default leafs
		for url, leafs of dirs
			if leafs.length == 1
				defleaf = leafs[0]
			if leafs
				for name in [ 'default', 'index', 'main' ]
					if name in leafs
						defleaf = name
						break
				if not defleaf
					throw "Cannot choose default dir index for #{url}"
				redir app, url, url+'/'+defleaf
				console.log "Dir #{url}/{->#{defleaf}}"

	else
		console.log 'No routes'
		process.exit()


expand_globs = ( patterns )->
	_.flattenDeep [ glob.sync p for p, i in patterns ]


reload_on_change = ( app, ctx )->
	config_watch = ctx.noderoot + '/config/**/*'
	paths = expand_globs [ config_watch ]
	console.log 'Watching configs: ', paths
	for fn in paths
		fs.watchFile fn, ( cur, prev )->
			console.log "Reloading config because: #{fn} changed"
			load_config ctx

	console.log 'Watching sitefile: ', ctx.lfn
	fs.watchFile ctx.lfn, ( cur, prev )->
		console.log "Reloading context because: #{ctx.lfn} changed"
		load_sitefile ctx
		console.log ctx.sitefile.specs


module.exports = {
	get_local_sitefile_name: get_local_sitefile_name,
	get_local_sitefile: get_local_sitefile,
	prepare_context: prepare_context,
	load_config: load_config,
	apply_routes: apply_routes,
	reload_on_change: reload_on_change
}

