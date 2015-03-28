path = require 'path'
express = require 'express'

init_express = ( app, ctx={} )->

	if not ctx.showStackError?
		ctx.showStackError = true
	app.set 'showStackError', ctx.showStackError

	#app.use express.static path.join ctx.noderoot, 'public'

module.exports = (ctx={})->

	app = express()

	#ctx.envname = app.get 'env'
	app.set 'env', ctx.envname

	ctx.port = process.env.PORT || 3000
	app.set 'port', ctx.port

	ctx.server = require("http").createServer(app)

	ctx.pkg_file = path.join ctx.noderoot, 'package.json'
	ctx.pkg = require( ctx.pkg_file )

	init_express( app, ctx )

	ctx.static_proto = express.static

	app
