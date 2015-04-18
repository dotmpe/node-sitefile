###
My usecase for context is not that big at the moment.

Just inherit the properties and add subcontexts.

###
express_handler = require '../../lib/sitefile/express'

Context = require '../../lib/context'


describe 'Module context', ->

  it 'exports a class called Context', ->
    expect( Context::constructor )
    expect( Context::constructor.name ).toBe 'Context'

  it 'should numerically Id its instances', ->
    expect( Context.count() ).toBe 0
    ctx1 = new Context {}
    expect( Context.count() ).toBe 1
    expect( ctx1.id() ).toBe 'ctx:1'
    ctx2 = new Context {}
    expect( Context.count() ).toBe 2
    expect( ctx2.id() ).toBe 'ctx:2'
    ctx3 = new Context {}
    expect( Context.count() ).toBe 3
    expect( ctx3.id() ).toBe 'ctx:3'


  describe 'contructor should accept', ->

    it 'a seed object', ->
      ctx = new Context foo: 'bar'
      expect( ctx.hasOwnProperty 'foo' ).toBe true
      expect( ctx.foo ).toBe 'bar'

    it 'a seed object and (super)context property object', ->
      ctx1 = new Context foo: 'bar'
      init = foo: 'bar2'
      ctx2 = new Context init, ctx1
      expect( ctx2.foo ).toBe 'bar2'
      expect( ctx2.context ).toBe ctx1
      expect( ctx1.foo ).toBe 'bar'


  describe 'instances', ->

    it 'should create and track subContexts, and override properties', ->
      ctx1 = new Context foo: 'bar'
      ctx2 = ctx1.getSub foo: 'bar2'
      expect( ctx1.foo ).toBe 'bar'
      expect( ctx2.foo ).toBe 'bar2'
      expect( ctx2.context ).toBe ctx1
      # track subcontexts
      expect( ctx1._subs[0] ).toBe ctx2
      # track subcontext ID
      expect( ctx2.id() ).toBe 'ctx:1.2'

    it 'should inherit property values, but not export values to the super context', ->
      ctx1 = new Context foo: 'bar'
      ctx2 = ctx1.getSub x: 9
      expect( ctx2.foo ).toBe 'bar'
      ctx1.foo = 'bar2'
      expect( ctx1.foo ).toBe 'bar2'
      expect( ctx2.foo ).toBe 'bar2'
      expect( ctx1.hasOwnProperty 'x' ).toBe false
      expect( ctx2.hasOwnProperty 'x' ).toBe true
      expect( ctx2.x ).toBe 9


    describe 'get path-reference', ->

      describe 'which dereference', ->

        it 'to objects', ->
          ctx = new Context foo: bar: el: 'baz'
          expect( ctx.get 'foo' ).toEqual bar: el: 'baz'
          expect( ctx.get 'foo.bar' ).toEqual el: 'baz'

        it 'to values--even if empty', ->
          ctx = new Context foo: bar:
            str: ''
            int: 0
            bool: false
          expect( ctx.get 'foo.bar.str' ).toBe ''
          expect( ctx.get 'foo.bar.int' ).toBe 0
          expect( ctx.get 'foo.bar.bool' ).toBe false

        it 'to objects with unresolved references', ->
          ctx = new Context
            foo: bar: $ref: '#/refs/x'
            refs: x: 0
          expect( ctx.get 'foo.bar' ).toEqual $ref: '#/refs/x'

      describe 'which resolve', ->

        it 'to fully dereferenced objects', ->
          ctx = new Context
            foo: bar: $ref: '#/refs/x'
            refs: x: el: 'baz'
          expect( ctx.resolve 'foo' ).toEqual bar: el: 'baz'
          expect( ctx.resolve 'foo.bar' ).toEqual el: 'baz'

        it 'to values', ->
          ctx = new Context foo: bar: el: 'baz'
          expect( ctx.resolve 'foo.bar.el' ).toEqual 'baz'

        it 'to referenced values', ->
          ctx = new Context
            foo: bar: $ref: '#/refs/x'
            refs: x: 0
          expect( ctx.resolve 'foo.bar' ).toBe 0

        it 'to values on referenced objects', ->
          ctx = new Context 
            foo: bar: $ref: '#/refs/x'
            refs: x: el: 'baz'
          expect( ctx.resolve 'foo.bar.el' ).toEqual 'baz'

        it 'to fully dereferenced objects (II)', ->
          ctx = new Context
            foo: bar: $ref: '#/refs/x'
            refs:
              x:
                el: 'baz'
                x2: $ref: '#/refs/x2'
              x2:
                int: 0
                bool: false
                x3: $ref: '#/refs/x3'
              x3: 'test'
          merged = foo: bar:
            el: 'baz'
            x2: int: 0, bool: false, x3: 'test'
          expect( ctx.resolve 'foo' ).toEqual merged.foo
          expect( ctx.resolve 'foo.bar' ).toEqual merged.foo.bar
          expect( ctx.resolve 'foo.bar.el' ).toEqual merged.foo.bar.el
          expect( ctx.resolve 'foo.bar.x2' ).toEqual merged.foo.bar.x2
          expect( ctx.resolve 'foo.bar.x2.bool' ).toEqual merged.foo.bar.x2.bool
          expect( ctx.resolve 'foo.bar.x2.int' ).toEqual merged.foo.bar.x2.int
          expect( ctx.resolve 'foo.bar.x2.x3' ).toEqual merged.foo.bar.x2.x3



  beforeEach ->
    Context.reset()
  afterEach ->
    delete ctx


