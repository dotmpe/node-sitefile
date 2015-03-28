fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
_ = require 'lodash'

get_local_sitefile_name = ( ctx={} )->
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

get_local_sitefile = (ctx={})->
	lfn = get_local_sitefile_name(ctx)
	if ctx.ext == '.json'
		sitefile = require lfn
	else if ctx.ext in [ '.yaml', '.yml' ]
		sitefile = yaml.safeLoad fs.readFileSync lfn, 'utf8'
	_.defaults sitefile, 
		routes: {}
		specs: {}
	sitefile

redir = ( app, r, p )->
	console.log 'redir', r, p
	app.all r, (req, res)->
		res.redirect p

apply_routes = ( sitefile, app, ctx={} )->

	_.defaults ctx, cwd: process.cwd(), base: '/'

	if not _.isEmpty sitefile.routes
		for route, strspec of sitefile.routes
			# FIXME: iterate routers and move spec parse to router
			r = ctx.base + route
			p = null
			if strspec.startsWith 'static:'
				p = path.join ctx.cwd, strspec.substr(7)
				app.use r, ctx.static_proto p
				console.log 'Static', r, p
			else if strspec.startsWith 'rst2html:'
				p = path.join ctx.cwd, strspec.substr(9)
				app.all r, ctx.rst2html p
				console.log 'rst2html', r, p
			else if strspec.startsWith 'redir:'
				p = '/'+strspec.substr 6
				redir app, r, p

	else
		console.log 'No routes'
		process.exit()

module.exports = {
	get_local_sitefile_name: get_local_sitefile_name,
	get_local_sitefile: get_local_sitefile,
	apply_routes: apply_routes
}
