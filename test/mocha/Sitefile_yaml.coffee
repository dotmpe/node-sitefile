# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee

chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

sewd = require 'selenium-webdriver'
browser = require 'selenium-webdriver/testing'

request = require 'request'
Promise = require 'bluebird'


lib = require '../../lib/sitefile'

tu = require './../test-utils'



describe """

The local Sitefile.yaml serves the local documentation, and doubles as an
example for all handlers.

""", ->


  stu = new tu.SitefileTestUtils()
  this.timeout 12000

  before stu.before.bind stu
  after stu.after.bind stu


  describe "should serve its own ReadMe", ->

    it "without problems", stu.test_url_ok "/ReadMe"

    it "redirect ReadMe.rst", stu.test_url_redirected "/ReadMe.rst"

    it "serve the correct type", stu.test_url_type_ok "/ReadMe", "html"


  it "should serve its own ChangeLog", stu.test_url_ok "/ChangeLog"


  it "should publish a CoffeeScript file to Javascript",
    stu.test_url_type_ok "/example/server-generated-javascript", "javascript"


  it "should publish a Pug file to HTML",
    stu.test_url_type_ok "/example/server-generated-page", "html"


  it "should publish a SASS file to CSS file",
    stu.test_url_type_ok "/example/server-generated-stylesheet-2", "css"


  it "should serve a Stylus file to CSS file",
    stu.test_url_type_ok "/example/server-generated-stylesheet", "css", \
      """
.example {
  font: 14px/1.5 Helvetica, arial, sans-serif;
}
.example #main {
  border: 1px solid #f00;
}
"""

  it "should serve routes for a local extension router example", ->

    tasks = [
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{stu.server.port}/sf-example/default"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          expect( body ).to.equal "Sitefile example"
          resolve()
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{stu.server.port}/sf-example/data1"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          data = JSON.parse body
          expect( data['sf-example'] ).to.equal 'dynamic'
          resolve()
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{stu.server.port}/sf-example/data2"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          data = JSON.parse body
          expect( data['sf-example'] ).to.equal 'static'
          resolve()
    ]

  ###
  if stu.module_installed 'pm2'
    it "should publish a PM2 client",
      stu.test_url_type_ok "/proc/pm2.html", "text/html"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2/"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2"
  ###


  it "should publish a client JS",
    stu.test_url_type_ok \
      "/media/script/sitefile-client.js", "application/javascript"

  it "should publish a client css",
    stu.test_url_type_ok "/media/style/default.css", "text/css"


  describe "has a Graphviz router for DOT diagram to PNG format", ->

    it "should render a PNG format",
      stu.test_url_type_ok \
        "/example/graphviz-binary-search-tree-graph.dot.png", "image/png"

    it "should redirect",
      stu.test_url_redirected "/example/graphviz-binary-search-tree-graph.dot"


  describe "has requirejs app", ->
  
    describe "at /app/v0", ->

      describe "with settings in Sitefile", ->


        it "from Sitefile", ( done ) ->
          obj = stu.ctx.sitefile.options.local["app/v0"]
          expect(obj).to.be.a 'object'
          expect(obj.clients).to.be.a 'object'
          clients = stu.ctx.resolve 'sitefile.options.local.app/v0.clients'
          expect(clients[0].type).to.equal 'require-js'
          expect(clients[0].href).to.equal '/vendor/require.js'

          stu.test_url_type_ok(clients[0].main, "application/javascript") done


      describe "that loads page that", ->


        before ->
          @driver = new sewd.Builder().
            withCapabilities(sewd.Capabilities.chrome()).
            build()
          chai.use require('chai-webdriver') @driver
          @driver.getWindowHandle()

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
          expect('.container').dom.to.have.count 3

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


  describe "has a CDN-redirection router instance at vendor/", ->

    it "should serve require.js", stu.test_url_type_ok \
        "/vendor/require.js", "application/javascript"

    it "should serve coffee-script.js", stu.test_url_type_ok \
        "/vendor/coffee-script.js", "application/javascript"

    it "should serve bootstrap.css", stu.test_url_type_ok \
        "/vendor/bootstrap.css", "text/css"

    it "should serve bootstrap-theme.css", stu.test_url_type_ok \
        "/vendor/bootstrap-theme.css", "text/css"

    it "should serve jquery.js", stu.test_url_type_ok \
        "/vendor/jquery.js", "application/javascript"

    it "should serve jqueryui.js", stu.test_url_type_ok \
        "/vendor/jqueryui.js", "application/javascript"

    it "should serve lodash.js", stu.test_url_type_ok \
        "/vendor/lodash.js", "application/javascript"

    it "should serve underscore.js", stu.test_url_type_ok \
        "/vendor/underscore.js", "application/javascript"

    it "should serve underscore.string.js", stu.test_url_type_ok \
        "/vendor/underscore.string.js", "application/javascript"

    it "should serve mocha.css", stu.test_url_type_ok \
        "/vendor/mocha.css", "text/css"

    it "should serve mocha.js", stu.test_url_type_ok \
        "/vendor/mocha.js", "application/javascript"

    it "should serve chai.js", stu.test_url_type_ok \
        "/vendor/chai.js", "application/javascript"

    it "should serve sinon.js", stu.test_url_type_ok \
        "/vendor/sinon.js", "application/javascript"




