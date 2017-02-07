# Id: node-sitefile/0.0.7-dev test/mocha/lib_sitefile_index.coffee
chai = require 'chai'
expect = chai.expect
path = require 'path'
_ = require 'lodash'

lib = require '../../lib/sitefile'
pkg = require '../../package.json'

tu = require '../test-utils'
yaml = require 'js-yaml'


describe 'Module sitefile', ->

  lib.log_enabled = false


  describe '.version', ->

    it 'should be valid semver', ->
      expect( lib.version ).to.match /^[0-9]+\.[0-9]+\.[0-9]+/

    it 'should equal package versions', ->
      expect( lib.version ).to.eql pkg.version


  describe '.get_local_sitefile_path', ->

    it 'should use options', ->

      ctx = lib.prepare_context()
      lib.get_local_sitefile_path ctx
      expect( _.keys( ctx.config.sitefile ) ).to.eql [
        'basename', 'exts', 'name', 'ext', 'path' ]

    it 'should export default option values', ->

      ctx = lib.prepare_context()
      sitefile_path = lib.get_local_sitefile_path ctx
      sfopts = ctx.config.sitefile
      expect( sfopts.path ).to.eql sitefile_path
      expect( sfopts.name ).to.eql 'Sitefile.yaml'
      expect( sfopts.basename ).to.eql 'Sitefile'
      expect( sfopts.ext ).to.eql '.yaml'
      expect( sfopts.exts ).to.eql [
        '.json'
        '.yml'
        '.yaml'
      ]

    it 'should pick up the local Sitefile.yaml', ->

      ctx = lib.prepare_context()
      sitefile_path = lib.get_local_sitefile_path ctx
      lfn = path.join process.cwd(), 'Sitefile.yaml'
      expect( sitefile_path ).to.eql( lfn )

    it 'should pick up Sitefiles for all extensions'
      # TODO: skip

    it 'should throw "No Sitefile"'
      # TODO: skip


  describe 'Root context', ->

    it 'Should be valid (site 0)', ->
      stu = new tu.SitefileTestUtils 'example/site/0'
      stu.load_ajv_schema 'sfctx_v', 'var/sitefile-context.yaml'

      ctx_v = stu.schema.sfctx_v
      ctx = lib.prepare_context()
      if not ctx_v ctx
        throw new Error '\n'+ yaml.dump ctx_v.errors


    it 'Should be valid (site 1)', ->
      stu = new tu.SitefileTestUtils 'example/site/1'
      stu.load_ajv_schema 'sfctx_v', 'var/sitefile-context.yaml'

      ctx_v = stu.schema.sfctx_v
      ctx = lib.prepare_context()
      if not ctx_v ctx
        throw new Error '\n'+ yaml.dump ctx_v.errors

    it 'Should load settings from the sitefile', ->
      ctx = lib.prepare_context()
      expect( ctx.settings.site.port ).to.eql 7012
      lib.load_sitefile_ctx ctx
      expect( ctx.sitefile.port ).to.be.undefined
      expect( ctx.settings.site.port ).to.eql 7012


  describe '.new_context', ->

    it 'Should return an object', ->
      ctx = lib.new_context()
      #expect( ctx ).to.eqlDefined()
      #expect( ctx ).to.eqlTruthy()
      expect( ctx ).to.be.an.object

    describe 'accepts options', ->
      it 'object', ->
        ctx = {}
        lib.new_context ctx

    it 'Should export options', ->
      ctx = {}
      lib.new_context ctx
      sfctx = ( "config cwd env "+
        "log noderoot paths pkg proc routes settings "+
        "sitefile verbose version"
      ).split ' '
      ctxkys = _.keys( ctx )
      ctxkys.sort()
      expect( ctxkys ).to.eql sfctx

    it 'Should load the config', ->
      ctx = lib.new_context()
      expect( ctx.config ).to.be.an.object


    it 'Should load rc ', ->
      ctx = lib.new_context()
      expect( ctx.config.static.sitefile.sitefilerc ).to.eql pkg.version


    it 'Should load the sitefile', ->
      ctx = lib.new_context()
      expect( ctx.sitefile ).to.be.an.object
      expect( ctx.sitefile.sitefile ).to.eql pkg.version


    it 'Should use static defaults ', ->

    it 'Should use env settings', ->
      # FIXME ctx = lib.new_context env: name: 'foo'
      #expect( ctx.env.name ).to.eql 'testing'

    it 'Should use user-config settings', ->
      ctx = lib.new_context()
      expect( ctx.config.static ).to.be.an.object



  describe 'local Sitefile', ->

    it 'contains references, globalized after loading', ->

      ctx = lib.new_context()
      expect( ctx.get 'sitefile.options.global.rst2html.stylesheets' ).to.eql {
        $ref: '#/sitefile/defs/stylesheets/default'
      }
      obj = ctx.resolve 'sitefile.options.global.rst2html.stylesheets'
      expect( obj ).to.be.an.array


  describe 'load sitefile', ->

    sitefile = {
      sitefile: '0.0.4'
      routes:
        _du: 'du:**/*.rst'
        _gv: 'gv:**/*.gv'
        '': 'redir:main'
        'default.css': 'sass:default.sass'
        'default.js': 'coffee:default.coffee'
    }

    it 'has expected sitefile routes/options (site 2)', ->
      stu = new tu.SitefileTestUtils 'example/site/2'
      obj = stu.get_sitefile()
      expect( obj ).to.eql sitefile


    sitefile_2 = {
      sitefile: '0.0.7-dev'
      routes: {}
      options:
        global:
          du:
            link_stylesheets: true
            scripts:
              $ref: '#/sitefile/defs/scripts/default'
      defs:
        scripts:
          default: [
            '/vendor/jquery.js'
          ]
    }

    it 'has expected sitefile routes/options (site 3, JSON)', ->
      stu = new tu.SitefileTestUtils 'example/site/3'
      obj = stu.get_sitefile()
      #sitefile_2.path = "Sitefile.json"
      expect( obj ).to.eql sitefile_2

    it 'has expected sitefile routes/options (site 4, YAML)', ->
      stu = new tu.SitefileTestUtils 'example/site/4'
      obj = stu.get_sitefile()
      #sitefile_2.path = "Sitefile.yml"
      expect( obj ).to.eql sitefile_2


  describe "uses JSON schema", ->

    stu = new tu.SitefileTestUtils()
    stu.load_ajv_schema 'ex1', 'example/json-schema.json'
    stu.load_ajv_schema 'ac_full', 'var/autocomplete-schema.json'
    stu.load_ajv_schema 'ac_simple', 'var/autocomplete-schema-1.json'

    it "to validate and invalidate data", ->
      ex1 = stu.schema.ex1
      expect( ex1 1.5 ).to.equal true
      expect( ex1 5 ).to.equal true
      expect( ex1 4 ).to.equal true
      expect( ex1 4.5 ).to.equal false
      expect( ex1 2.5 ).to.equal true
      expect( ex1 3.5 ).to.equal false

      ac_simple = stu.schema.ac_simple
      expect( ac_simple ["string"] ).to.equal true
      expect( ac_simple [{"foo":"string"}] ).to.equal false
      expect( ac_simple [{"label":"Foo"}] ).to.equal false

      ac_full = stu.schema.ac_full
      expect( ac_full ["string"] ).to.equal true
      expect( ac_full [{"foo":"string"}] ).to.equal false
      expect( ac_full [{"label":"Foo"}] ).to.equal true
      expect( ac_full [{"category":"Foo"}] ).to.equal false
      expect( ac_full [{"label":"Foo", "category":"Notes"}] ).to.equal true


    it "to validate AC data (Simple)", -> stu.req_json_file_valid \
      "../example/autocomplete-data-2.json", stu.schema.ac_simple

    it "to (in)validate AC data (Full)", ->
      v = stu.schema.ac_full
      Promise.all [
        stu.req_json_file_valid "../example/autocomplete-data.json", v
        stu.req_json_file_valid "../example/data.json", v, false
        stu.req_json_file_valid "../example/autocomplete-data-1.json", v, false
      ]


