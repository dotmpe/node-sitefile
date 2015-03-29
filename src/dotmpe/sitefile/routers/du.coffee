###
Work in progress docutils router for sitefile.

XXX: get all dependencies somehow, and route them?
XXX: du.mpe compatible with fallback or?
###
_ = require 'lodash'
path = require 'path'

librst2html = require './rst2html'

module.exports = ( ctx={} )->

	rst2html = librst2html(ctx).lib.rst2html

	_.defaults ctx,
		# base-url / prefix for local routes
		base_url: 'dotmpe'

	name: 'du'
	label: 'Docutils'
	default:
		# default du: action
		'all_handler'

	# generators for Sitefile route handlers
	generate:
		all_handler: ( spec )->
			###
			du.all_handler:docs/**.rst
			###
			docpath = path.join ctx.cwd, spec
			( req, res, next )->
				req.query = _.defaults req.query || {}, 
					format: 'html',
					docpath: docpath
				try
					rst2html res, _.merge {}, ctx.specs.rst2html, req.query
				catch error
					console.log error
					res.type('text/plain')
					res.status(500)
					res.write("exec error: "+error)
					res.end()


	route:
		base: ctx.base_url
		# local route handlers
		du: 
			get: (req, res, next)->

