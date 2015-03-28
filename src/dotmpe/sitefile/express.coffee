path = require 'path'
express = require 'express'

String::startsWith ?= (s) -> @[...s.length] is s
String::endsWith   ?= (s) -> s is '' or @[-s.length..] is s


init_express = ( app, ctx={} )->

	if not ctx.showStackError?
		ctx.showStackError = true
	app.set 'showStackError', ctx.showStackError

	#app.use express.static path.join ctx.noderoot, 'public'

module.exports = (ctx={})->

	app = express()

	#envname = process.env.NODE_ENV or 'development'
	ctx.envname = app.get 'env'

	ctx.port = process.env.PORT || 3000
	app.set 'port', ctx.port

	ctx.server = require("http").createServer(app)

	ctx.configs = require path.join ctx.noderoot, 'config/config'
	ctx.config = ctx.configs[ctx.envname]

	ctx.pkg_file = path.join ctx.noderoot, 'package.json'
	ctx.pkg = require( ctx.pkg_file )

	init_express( app, ctx )

	ctx.static_proto = express.static

	app
