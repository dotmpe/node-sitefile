# Id: node-sitefile/0.0.5-dev test/mocha/lib_sitefile_index.coffee
chai = require 'chai'
expect = chai.expect
path = require 'path'
_ = require 'lodash'

lib = require '../../lib/sitefile'
pkg = require '../../package.json'

Ajv = require 'ajv'

tu = require '../test-utils'


describe 'Module sitefile', ->

  lib.log_enabled = false


  describe '.version', ->

    it 'should be valid semver', ->
      expect( lib.version ).to.match /^[0-9]+\.[0-9]+\.[0-9]+/

    it 'should equal package versions', ->
      expect( lib.version ).to.eql pkg.version


  describe '.get_local_sitefile_name', ->

    it 'should use options', ->

      ctx = {}
      sitefile_fn = lib.get_local_sitefile_name ctx
      expect( _.keys( ctx) ).to.eql [ 'basename', 'exts', 'fn', 'ext', 'lfn' ]

    it 'should export default option values', ->

      ctx = {}
      sitefile_fn = lib.get_local_sitefile_name ctx
      expect( ctx.lfn ).to.eql sitefile_fn
      expect( ctx.fn ).to.eql 'Sitefile.yaml'
      expect( ctx.basename ).to.eql 'Sitefile'
      expect( ctx.ext ).to.eql '.yaml'
      expect( ctx.exts ).to.eql [
        '.json'
        '.yml'
        '.yaml'
      ]

    it 'should pick up the local Sitefile.yaml', ->

      ctx = {}
      sitefile_fn = lib.get_local_sitefile_name ctx
      lfn = path.join process.cwd(), 'Sitefile.yaml'
      expect( sitefile_fn ).to.eql( lfn )

    it 'should pick up Sitefiles for all extensions'


    it 'should throw "No Sitefile"'


  describe '.prepare_context', ->

    it 'Should return an object', ->
      ctx = lib.prepare_context()
      #expect( ctx ).to.eqlDefined()
      #expect( ctx ).to.eqlTruthy()
      expect( ctx ).to.be.an.object


    describe 'accepts options', ->
      it 'object', ->
        ctx = {}
        lib.prepare_context ctx


    it 'Should export options', ->
      ctx = {}
      lib.prepare_context ctx
      sfctx = ( "basename bundles config config_envs config_name cwd envname "+
        "ext exts fn lfn log noderoot paths pkg pkg_file proc routes "+
        "site sitefile sitefilerc static verbose version"
      ).split ' '
      ctxkys = _.keys( ctx )
      ctxkys.sort()
      expect( ctxkys ).to.eql sfctx

    it 'Should load the config', ->
      ctx = lib.prepare_context()
      expect( ctx.config ).to.be.an.object

    it 'Should load rc ', ->
      ctx = lib.prepare_context()
      expect( ctx.sitefilerc ).to.eql pkg.version

    it 'Should load the sitefile', ->
      ctx = lib.prepare_context()
      expect( ctx.sitefile ).to.be.an.object
      expect( ctx.sitefile.sitefile ).to.eql pkg.version


  describe 'local Sitefile', ->

    it 'contains references, globalized after loading', ->

      ctx = lib.prepare_context()
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
      path: "Sitefile.yml"
    }

    it 'has expected sitefile routes/options (site 2)', ->
      stu = new tu.SitefileTestUtils 'example/site/2'
      obj = stu.get_sitefile()
      expect( obj ).to.eql sitefile


    sitefile_2 = {
      sitefile: '0.0.5-dev'
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
            '/vendor/jquery.js' ]
      path: "Sitefile.yml"
    }

    it 'has expected sitefile routes/options (site 3, JSON)', ->
      stu = new tu.SitefileTestUtils 'example/site/3'
      obj = stu.get_sitefile()
      sitefile_2.path = "Sitefile.json"
      expect( obj ).to.eql sitefile_2

    it 'has expected sitefile routes/options (site 4, YAML)', ->
      stu = new tu.SitefileTestUtils 'example/site/4'
      obj = stu.get_sitefile()
      sitefile_2.path = "Sitefile.yml"
      expect( obj ).to.eql sitefile_2


  describe "uses JSON schema", ->

    stu = new tu.SitefileTestUtils()
    stu.load_schema 'ex1', 'example/json-schema.json'
    stu.load_schema 'ac_full', 'var/autocomplete-schema.json'
    stu.load_schema 'ac_simple', 'var/autocomplete-schema-1.json'

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


