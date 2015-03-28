path = require 'path'

lib = require '../../src/dotmpe/sitefile'


describe 'sitefile.get_local_sitefile_name', ->

	it 'Should use options', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx

	it 'Should export default options and context', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx
		expect( ctx.fn ).toEqual 'Sitefile.yaml'
		expect( ctx.lfn ).toEqual sitefile_fn
		expect( ctx.ext ).toEqual '.yaml'
		expect( ctx.basename ).toEqual 'Sitefile'
		expect( ctx.exts ).toEqual [
			'.json'
			'.yml'
			'.yaml'
		]

	it 'Should pick up the local Sitefile.yaml', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx
		lfn = path.join __nodepath, 'Sitefile.yaml'
		expect( sitefile_fn ).toEqual( lfn )

	it 'Should pick up Sitefiles for all extensions', ->


	it 'Should throw "No Sitefile"', ->


describe 'sitefile.get_local_sitefile', ->

describe 'sitefile.apply_routes', ->
	it 'should pass', ->
		expect( 2 + 2 ).toEqual 4


