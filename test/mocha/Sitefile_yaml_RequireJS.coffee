
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


  describe "has RequireJS app", ->
  
    describe "at /app/v0", ->

      describe "with settings", ->

        it "in Sitefile", ->

          obj = stu.ctx.sitefile.options.local["app/v0"]
          expect(obj).to.be.a 'object'
          expect(obj.merge).to.be.a 'object'
          expect(obj.merge.clients).to.eql [{
            type: 'require-js'
            id: 'require-js-sitefile-v0-app'
            href: '/vendor/require.js'
            main: '/app/rjs-sf-v0.js'
          }]
          expect(obj.merge.stylesheets).to.eql [
            '/vendor/bootstrap.css'
            '/vendor/jquery-ui.css'
          ]
          clients = stu.ctx.resolve \
                    'sitefile.options.local.app/v0.merge.clients'
          expect(clients).to.be.a 'array'
          expect(clients[0].type).to.equal 'require-js'
          expect(clients[0].href).to.equal '/vendor/require.js'
          stu.test_url_type_ok(clients[0].main, "application/javascript")

  
      describe "that loads a page that", ->

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
          @driver.get "http://localhost:#{stu.server.port}/app/v0"

        after ->
          @driver.quit()


        browser.it "has docutils elements (document/header/footer)", ->
          Promise.all [
            expect('.document').dom.to.have.count 1
            #expect('.document').dom.to.have.attribute 'sf-page'
            expect('.header').dom.to.have.count 1
            expect('h1.title').dom.to.contain.text "Sitefile"
          ]


        browser.it "has one or more bootstrap container", ->
          driver = @driver
          new Promise ( resolve, reject ) ->
            driver.wait(
              sewd.until.elementLocated sewd.By.className 'container'
            ).catch( reject ).then ->
              driver.getWindowHandle()
              Promise.all([
                expect('.container').dom.to.have.count 4
              ]).catch( reject ).then resolve


        browser.it "has dynamic breadcrumb", ->
          driver = @driver
          new Promise ( resolve, reject ) ->
            driver.wait(
              sewd.until.elementLocated sewd.By.className 'breadcrumb'
            ).catch( reject ).then ->
              driver.getWindowHandle()
              Promise.all([
                expect('.breadcrumb').dom.to.have.count 1
                expect('ol.breadcrumb').dom.to.have.count 1
                expect('.breadcrumb > *').dom.to.have.count 5
              ]).catch( reject ).then resolve



    describe "with config/init from", ->

      it "rjs-sf-v0.json", stu.test_url_type_ok \
          "/app/rjs-sf-v0.json", "application/json"

      it "rjs-sf-v0.js", stu.test_url_type_ok \
          "/app/rjs-sf-v0.js", "application/javascript"





