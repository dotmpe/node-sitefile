

chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'

lib = require '../../lib/sitefile'

tu = require '../test-utils'


describe "Example site 2", ->
  stu = new tu.SitefileTestUtils()
  describe "is a simple Sitefile YAML example", ->
    it "redirects to /main", ->
    it "holds no options or other attributes", ->
    it "TOTEST: runs on 0.0.4?", ->

