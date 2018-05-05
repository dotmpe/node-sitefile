# Id: node-sitefile/0.0.7-dev test/mocha/lib_dotmpe_conf.coffee
fs = require 'fs'
chai = require 'chai'
expect = chai.expect

sitefile = require '../../lib/sitefile'
libconf = require '../../lib/conf'
pkg = require '../../package.json'


describe "Module conf", ->


  describe ".get:", ->

    it "Should get the name of the nearest Sitefile", ->
      rc = libconf.get 'Sitefile', paths: [ '.' ]
      expect( rc ).to.eql "Sitefile.yaml"

    it "Should get the path of the nearest sitefilerc", ->
      rc = libconf.get 'sitefilerc', suffixes: [ '' ]
      expect( rc ).to.eql ".sitefilerc"

    it "Should get the names of all the sitefilerc", ->
      rcs = libconf.get 'sitefilerc', suffixes: [ '' ], all: true
      if fs.existsSync process.env.HOME
        expect( rcs ).to.eql [
          '.sitefilerc',
        # XXX: relative path is of no use here..
          "../..#{process.env.HOME}/.sitefilerc"
        ]
      else
        expect( rcs ).to.eql [ '.sitefilerc' ]


  describe ".load_file:", ->

    it "Should load the data of a sitefilerc", ->
      rc = libconf.get 'sitefilerc', suffixes: [ '' ]
      data = libconf.load_file rc
      expect( data ).to.eql sitefilerc: pkg.version


  describe ".load", ->

    it "Should load the data of the nearest sitefilerc", ->
      data = libconf.load 'sitefilerc', get: suffixes: [ '' ]
      expect( data ).to.eql sitefilerc: pkg.version
