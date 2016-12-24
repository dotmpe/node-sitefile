# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee
chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'

lib = require '../../lib/sitefile'

tu = require './../test-utils'


describe "The local Sitefile.yaml serves the local documentation, and
doubles is an example for all handlers. ", ->

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


  it "should serve routes for a local extension router example", ( done ) ->

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
    Promise.all( tasks ).then -> done()

    null

  if stu.module_installed 'pm2'
    it "should publish a PM2 client",
      stu.test_url_type_ok "/proc/pm2.html", "text/html"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2/"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2"

  it "should publish a client JS",
    stu.test_url_type_ok "/client/default.js", "application/javascript"

  it "should publish a client css",
    stu.test_url_type_ok "/style/default.css", "text/css"


