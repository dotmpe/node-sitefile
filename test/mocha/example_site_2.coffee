chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'
yaml = require 'js-yaml'

lib = require '../../lib/sitefile'
tu = require '../test-utils'


describe "Example site 2", ->

  stu = new tu.SitefileTestUtils 'example/site/2'
  before stu.before.bind stu
  after stu.after.bind stu

  describe "is a simple Sitefile YAML example", ->
    it "redirects to /main", -> stu.test_url_redirected "/", "/main"
    it "holds no options or other attributes", ->
      expect( stu.ctx.sitefile ).to.have.ownProperty 'routes'
      expect( stu.ctx.sitefile ).to.not.have.ownProperty 'options'
      expect( stu.ctx.sitefile ).to.not.have.ownProperty 'port'
      expect( stu.ctx.sitefile ).to.not.have.ownProperty 'paths'
      expect( stu.ctx.sitefile ).to.not.have.ownProperty 'defaults'
      expect( stu.ctx.sitefile ).to.not.have.ownProperty 'defs'
    it "TOTEST: runs on 0.0.4?", ->


  describe 'Root context', ->

    stu.load_ajv_schema 'sfctx_v', 'var/sitefile-context.yaml'


    it 'Should be valid (I)', ->

      ctx_v = stu.schema.sfctx_v
      ctx = lib.prepare_context()
      if not ctx_v ctx
        throw new Error '\n'+ yaml.dump ctx_v.errors


