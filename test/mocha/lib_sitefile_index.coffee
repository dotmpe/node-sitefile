# Id: node-sitefile/0.0.4-dev-fdata test/mocha/lib_sitefile_index.coffee
chai = require 'chai'
expect = chai.expect
path = require 'path'
_ = require 'lodash'

lib = require '../../lib/sitefile'
pkg = require '../../package.json'
bwr = require '../../bower.json'


describe 'Module sitefile', ->

  lib.log_enabled = false


  describe '.version', ->

    it 'should be valid semver', ->
      expect( lib.version ).to.match /^[0-9]+\.[0-9]+\.[0-9]+/

    it 'should equal package versions', ->
      expect( lib.version ).to.eql pkg.version
      expect( lib.version ).to.eql bwr.version


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
      sfctx = ( "basename config config_envs config_name cwd envname "+
        "ext exts fn lfn noderoot pkg pkg_file port proc routers sitefile "+
        "sitefilerc static version"
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
      expect( ctx.get 'sitefile.params.rst2html.stylesheets' ).to.eql {
        $ref: '#/sitefile/defs/stylesheets/default'
      }
      obj = ctx.resolve 'sitefile.params.rst2html.stylesheets'
      expect( obj ).to.be.an.array



