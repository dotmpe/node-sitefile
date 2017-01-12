chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'
yaml = require 'js-yaml'

lib = require '../../lib/sitefile'
tu = require '../test-utils'


describe "Example site 0", ->

  stu = new tu.SitefileTestUtils 'example/site/0'
  before stu.before.bind stu
  after stu.after.bind stu


  describe 'Root context', ->

    stu.load_ajv_schema 'sfctx_v', 'var/sitefile-context.yaml'


    it 'Should have valid root context', ->

      ctx_v = stu.schema.sfctx_v
      ctx = lib.prepare_context()
      if not ctx_v ctx
        throw new Error '\n'+ yaml.dump ctx_v.errors


    it 'Should load settings from the sitefile', ->
      ctx = lib.prepare_context()
      expect( ctx.settings.site.port ).to.eql 8632
      lib.load_sitefile_ctx ctx
      expect( ctx.sitefile.port ).to.eql 8632


