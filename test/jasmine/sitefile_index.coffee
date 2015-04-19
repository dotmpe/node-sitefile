path = require 'path'
_ = require 'lodash'

lib = require '../../lib/sitefile'
pkg = require '../../package.json'
bwr = require '../../bower.json'

describe 'Module sitefile', ->

  lib.log_enabled = false

  describe '.version', ->
    it 'Should be valid semver', ->
      expect( lib.version ).toMatch /^[0-9]+\.[0-9]+\.[0-9]+/
    it 'Should equal package versions', ->
      expect( lib.version ).toEqual pkg.version
      expect( lib.version ).toEqual bwr.version

  describe '.get_local_sitefile_name', ->

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
      lfn = path.join process.cwd(), 'Sitefile.yaml'
      expect( sitefile_fn ).toBe( lfn )

    it 'Should pick up Sitefiles for all extensions', ->


    it 'Should throw "No Sitefile"', ->


  describe '.prepare_context', ->

    it 'Should return an object', ->
      ctx = lib.prepare_context()
      expect( ctx ).toBeDefined()
      expect( ctx ).toBeTruthy()
      expect( ctx ).toEqual( jasmine.any Object )

    describe 'accepts options', ->
      it 'object', ->
        ctx = {}
        lib.prepare_context ctx

    it 'Should export options', ->
      ctx = {}
      lib.prepare_context ctx
      sfctx = ( "basename config config_envs config_name cwd envname "+
        "ext exts fn lfn noderoot pkg pkg_file proc routers sitefile "+
        "sitefilerc static version"
      ).split ' '
      ctxkys = _.keys( ctx )
      ctxkys.sort()
      expect( ctxkys ).toEqual sfctx

    it 'Should load the config', ->
      ctx = lib.prepare_context()
      expect( ctx.config ).toEqual jasmine.any Object

    it 'Should load rc ', ->
      ctx = lib.prepare_context()
      expect( ctx.sitefilerc ).toEqual pkg.version

    it 'Should load the sitefile', ->
      ctx = lib.prepare_context()
      expect( ctx.sitefile ).toEqual jasmine.any Object
      expect( ctx.sitefile.sitefile ).toEqual pkg.version


  describe 'local Sitefile', ->

    it 'contains references, globalized after loading', ->

      ctx = lib.prepare_context()
      expect( ctx.get 'sitefile.params.rst2html.stylesheets' ).toEqual {
        $ref: '#/sitefile/defs/stylesheets/default'
      }
      obj = ctx.resolve 'sitefile.params.rst2html.stylesheets' 
      expect( obj ).toEqual jasmine.any Array


