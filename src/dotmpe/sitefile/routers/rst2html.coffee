_ = require 'lodash'
fs = require 'fs'
child_process = require 'child_process'


###
Async rst2html writes to out or throws exception
###
rst2html = ( out, ctx={} )->

	_.defaults ctx,
		format: 'pseudoxml'
		docpath: 'index'

	cmd = "rst2#{ctx.format}.py '#{ctx.docpath}.rst'"

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


module.exports =

	generate:
		single_name_handler: ( path )->
			( req, res, next )->
				req.query = _.defaults req.query || {}, 
					format: 'html',
					docpath: path
				try
					rst2html res, req.query
				catch error
					console.log error
					res.type('text/plain')
					res.status(500)
					res.write("exec error: "+error)
					res.end()


	meta:
		route:
			rst2html:
				get: (req, res, next)->
				
					req.query = _.defaults res.query || {}, format: 'xml' 

					try
						rst2html res, req.query
					catch error
						console.log error
						res.type('text/plain')
						res.status(500)
						res.write("exec error: "+error)
					res.end()

