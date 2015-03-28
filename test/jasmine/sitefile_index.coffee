path = require 'path'
_ = require 'lodash'

lib = require '../../src/dotmpe/sitefile'


describe 'sitefile.get_local_sitefile_name', ->

	it 'Should use options', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx
		expect( _.keys( ctx) ).toEqual [ 'basename', 'exts', 'fn', 'ext', 'lfn' ]

	it 'Should export default option values', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx
		expect( ctx.lfn ).toBe sitefile_fn
		expect( ctx.fn ).toBe 'Sitefile.yaml'
		expect( ctx.basename ).toBe 'Sitefile'
		expect( ctx.ext ).toBe '.yaml'
		expect( ctx.exts ).toEqual [
			'.json'
			'.yml'
			'.yaml'
		]

	it 'Should pick up the local Sitefile.yaml', ->

		ctx = {}
		sitefile_fn = lib.get_local_sitefile_name ctx
		lfn = path.join __nodepath, 'Sitefile.yaml'
		expect( sitefile_fn ).toBe( lfn )

	it 'Should pick up Sitefiles for all extensions', ->


	it 'Should throw "No Sitefile"', ->


describe 'sitefile.get_local_sitefile', ->

describe 'sitefile.apply_routes', ->


