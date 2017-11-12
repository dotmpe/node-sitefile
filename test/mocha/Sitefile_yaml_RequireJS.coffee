
_ = require 'lodash'
chai = require 'chai'
#chai.use require 'chai-as-promised'
expect = chai.expect

request = require 'request'
Promise = require 'bluebird'


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
            { url: "/vendor/jquery-ui.css"}
            { url: "/vendor/jquery-terminal.css"}
            { url: "/vendor/bootstrap.css"}
            { url: "/vendor/bootstrap-theme.css"}
            { url: "/vendor/bootstrap-table.css"}
            { url: "/media/style/default.css"}
          ]

          clients = stu.ctx.resolve \
                    'sitefile.options.local.app/v0.merge.clients'
          expect(clients).to.be.a 'array'
          expect(clients[0].type).to.equal 'require-js'
          expect(clients[0].href).to.equal '/vendor/require.js'
          stu.test_url_type_ok(clients[0].main, "application/javascript")

      #stu.verify_pattern ->
      #_loads_a_page_that stu, sewd, browser
      #_loads_a_page_that = ( stu, sewd, browser ) ->
      describe "that loads a page that", ->

        sewd = require 'selenium-webdriver'
        browser = require 'selenium-webdriver/testing'
        before ->
          if stu.ctx.verbose
            console.log 'requesting', stu.env_browser()
          try
            @driver = new sewd.Builder().
              withCapabilities(
                browserName: stu.env_browser()
              ).
              build()
          catch err
            console.warn "Skipped SeWD test: #{err}"
            this.skip()
          chai.use require('chai-webdriver') @driver

        beforeEach ->
          @driver.get "http://#{stu.server.host}:#{stu.server.port}/app/v0"

        after ->
          @driver?.quit()

        browser.it "has docutils elements (document/header/footer)", ->
          Promise.all [
            expect('.document').dom.to.have.count 1
            #expect('.document').dom.to.have.attribute 'sf-page'
            expect('.header').dom.to.have.count 1
            #expect('h3.subtitle').dom.to.contain.text \
            #  "Sitefile v0 - RequireJS Client"
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


      #/_loads_a_page_that


    describe "at index", ->
      describe "that loads a page that", ->

        sewd = require 'selenium-webdriver'
        browser = require 'selenium-webdriver/testing'

        before ->
          if stu.ctx.verbose
            console.log 'requesting', stu.env_browser()
          try
            @driver = new sewd.Builder().
              withCapabilities(
                browserName: stu.env_browser()
              ).
              build()
          catch err
            console.warn err
            this.skip()
          chai.use require('chai-webdriver') @driver

        beforeEach ->
          @driver.get "http://#{stu.server.host}:#{stu.server.port}/index"

        after ->
          @driver?.quit()

        browser.it "has a global menu", ->
          driver = @driver
          new Promise ( resolve, reject ) ->
            driver.wait(
              sewd.until.elementLocated sewd.By.className 'menu-global'
            ).catch( reject ).then ->
              driver.getWindowHandle()
              Promise.all([
                expect('ul.nav.menu-global').dom.to.have.count 3
              ]).catch( reject ).then resolve

        browser.it "has site menu", ->
          driver = @driver
          new Promise ( resolve, reject ) ->
            driver.wait(
              sewd.until.elementLocated sewd.By.className 'menu-sites'
            ).catch( reject ).then ->
              driver.getWindowHandle()
              Promise.all([
                expect('ul.nav.menu-sites').dom.to.have.count 1
              ]).catch( reject ).then resolve

    describe "with config/init from", ->

      it "rjs-sf-v0.json", stu.test_url_type_ok \
          "/app/rjs-sf-v0.json", "application/json"

      it "rjs-sf-v0.js", stu.test_url_type_ok \
          "/app/rjs-sf-v0.js", "application/javascript"
