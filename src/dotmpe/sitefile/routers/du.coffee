###
Work in progress docutils router for sitefile.

TODO: process globs to dynamic routes somehow
XXX: get all dependencies somehow, and route them?
XXX: du.mpe compatible with fallback or?
###
_ = require 'lodash'


module.exports = ( ctx={} )->

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
			console.log 'TODO map all known du extensions?'

	route:
		base: ctx.base_url
		# local route handlers
		du: 
			get: (req, res, next)->

