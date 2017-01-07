
_ = require 'lodash'
chai = require 'chai'
#chai.use require 'chai-as-promised'
expect = chai.expect

sewd = require 'selenium-webdriver'
browser = require 'selenium-webdriver/testing'

request = require 'request'
Promise = require 'bluebird'
Ajv = require 'ajv'


lib = require '../../lib/sitefile'

tu = require './../test-utils'


describe "The local Sitefile.yaml serves the local documentation, and \
 doubles as an example for all handlers. Starting a server instance", ->

  stu = new tu.SitefileTestUtils()
  this.timeout 20000

  before stu.before.bind stu
  after stu.after.bind stu


  describe "has pages with polymer elements", ->
  
    before ->
      if stu.ctx.verbose
        console.log 'requesting', stu.env_browser()
      @driver = new sewd.Builder().
        withCapabilities(
          browserName: stu.env_browser()
        ).
        build()
      chai.use require('chai-webdriver') @driver

    beforeEach ->
      @driver.get \
        "http://localhost:#{stu.server.port}/example/polymer-paper-hello-world"

    after ->
      @driver.quit()


    browser.it "has working hello world", ->

      Promise.all [
        expect('paper-input').dom.to.have.count 1
        expect('paper-input').dom.to.have.htmlClass 'paper-input-0'
        expect('paper-input').dom.to.have.htmlClass 'x-scope'
        expect('paper-button').dom.to.have.count 1
        expect('paper-button').dom.to.have.htmlClass 'paper-button-0'
        expect('paper-button').dom.to.have.htmlClass 'x-scope'
      ]



