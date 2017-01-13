# Id: node-sitefile/0.0.5-dev test/mocha/lib_dotmpe_conf.coffee
path = require 'path'
chai = require 'chai'
expect = chai.expect

sitefile = require '../../lib/sitefile'
libconf = require '../../lib/conf'
pkg = require '../../package.json'


describe "Module conf", ->


  describe ".get ", ->

    it "returns the name of the nearest Sitefile", ->
      rc = libconf.get 'Sitefile', paths: [ '.' ]
      expect( rc ).to.eql "Sitefile.yaml"

    it "returns the path of the nearest sitefilerc", ->
      rc = libconf.get 'sitefilerc', suffixes: [ '' ]
      expect( rc ).to.eql ".sitefilerc"

    it "returns the names of all the sitefilerc", ->
      rcs = libconf.get 'sitefilerc', suffixes: [ '' ], all: true
      expect( rcs ).to.eql [ '.sitefilerc' ]


  describe ".expand_path ", ->

    it "replaces the 'lib:' prefix with the node-sitefile dir path", ->
      expect( libconf.expand_path 'lib:foo' ).to.be.a.string

      expected = path.join process.cwd(), 'lib', 'foo'
      expect( libconf.expand_path 'lib:foo' ).to.be.eql expected


  describe ".load_file ", ->

    it "loads data of a sitefilerc", ->
      rc = libconf.get 'sitefilerc', suffixes: [ '' ]
      data = libconf.load_file rc, {}, paths: data: {}
      expect( data ).to.eql sitefilerc: pkg.version


  describe ".load ", ->

    it "loads data of the nearest sitefilerc", ->
      try
        data = libconf.load 'sitefilerc', get: suffixes: [ '' ]
      catch err
        throw new Error "Failed loading sitefilerc: #{err}"
      expect( data ).to.be.an.object
      expect( data ).to.be.not.empty
      expect( data ).to.eql sitefilerc: pkg.version



