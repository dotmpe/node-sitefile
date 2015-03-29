###
My usecase for context is not that big at the moment.

Just inherit the properties and add subcontexts.

###
express_handler = require '../../src/dotmpe/sitefile/express'

Context = require '../../src/dotmpe/context'


describe 'context', ->
	it 'should accept a seed object', ->
		ctx = new Context foo: 'bar'
		expect( ctx.hasOwnProperty 'foo' ).toBe true
		expect( ctx.foo ).toBe 'bar'

	it 'should accept a seed and context object', ->
		ctx1 = new Context foo: 'bar'
		init = foo: 'bar2'
		ctx2 = new Context init, ctx1
		expect( ctx1.foo ).toBe 'bar'
		expect( ctx2.foo ).toBe 'bar2'
		expect( ctx2.context ).toBe ctx1

	it 'should create and track subContexts, and override propertie', ->
		ctx1 = new Context foo: 'bar'
		ctx2 = ctx1.getSub foo: 'bar2'
		expect( ctx1.foo ).toBe 'bar'
		expect( ctx2.foo ).toBe 'bar2'
		expect( ctx2.context ).toBe ctx1
		expect( ctx1._subs[0] ).toBe ctx2

	it 'should inherit unset properties, and not export properties', ->
		ctx1 = new Context foo: 'bar'
		ctx2 = ctx1.getSub x: 9
		expect( ctx2.foo ).toBe 'bar'
		ctx1.foo = 'bar2'
		expect( ctx1.foo ).toBe 'bar2'
		expect( ctx2.foo ).toBe 'bar2'
		expect( ctx1.hasOwnProperty 'x' ).toBe false
		expect( ctx2.hasOwnProperty 'x' ).toBe true
		expect( ctx2.x ).toBe 9


