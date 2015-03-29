_ = require 'lodash'
fs = require 'fs'
path = require 'path'
child_process = require 'child_process'


###
Async rst2html writes to out or throws exception
###
rst2html = ( out, ctx={} )->

	_.defaults ctx,
		format: 'pseudoxml'
		docpath: 'index'
		link_stylesheet: false
		stylesheets: []

	flags = []
	if ctx.stylesheets? and !_.isEmpty ctx.stylesheets
		sheets = ctx.stylesheets.join(',')
		flags.push "--stylesheet-path '#{sheets}'"
	cmdflags = flags.join(' ')

	cmd = "rst2#{ctx.format}.py #{cmdflags} '#{ctx.docpath}.rst'"

	if ctx.format == 'source'
		out.type 'text'
		out.write fs.readFileSync "#{ctx.docpath}.rst"
		out.end()

	else
	
		child_process.exec cmd, (error, stdout, stderr)->
			if error
				throw error
			else if ctx.format == 'xml'
				out.type 'xml'
				out.write(stdout)
			else if ctx.format == 'html'
				out.type 'html'
				out.write(stdout)
			else if ctx.format == 'pseudoxml'
				out.type 'text/plain'
				out.write(stdout)
			out.end()


module.exports = ( ctx={} )->

	_.defaults ctx, 

		# base-url / prefix for local routes
		base_url: null

	name: 'rst2html'
	label: 'Docutils rst-to-html'
	default:
		# default rst2html: action
		'single_name_handler'

	lib:
		rst2html: rst2html
	generate:
		single_name_handler: ( spec )->
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
		rst2html:
			get: (req, res, next)->
			
				req.query = _.defaults res.query || {}, format: 'xml' 

				try
					rst2html res, _.merge {}, ctx.specs.rst2html, req.query
				catch error
					console.log error
					res.type('text/plain')
					res.status(500)
					res.write("exec error: "+error)
				res.end()

