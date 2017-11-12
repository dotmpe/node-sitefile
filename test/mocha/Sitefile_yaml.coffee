_ = require 'lodash'
chai = require 'chai'
#chai.use require 'chai-as-promised'
expect = chai.expect
#assert = chai.assert

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


  describe "serves the", ->

    it "README okay", stu.test_url_ok "/README"
    it "redirect index.rst", stu.test_url_redirected "/index.rst"
    it "ChangeLog okay", stu.test_url_ok "/ChangeLog"
    it "correct type for README", stu.test_url_type_ok "/README", "html"
    it "correct type for index", stu.test_url_type_ok "/index", "html"
    it "correct type for ChangeLog", stu.test_url_type_ok "/ChangeLog", "html"

  
  describe "has various other types", ->

    it "should publish a CoffeeScript file to Javascript",
      stu.test_url_type_ok "/example/server-generated-javascript", "javascript"

    it "should publish a Pug file to HTML",
      stu.test_url_type_ok "/example/server-generated-page", "html"

    it "should publish a Pug file to HTML (2)",
      stu.test_url_type_ok "/example/server-generated-page-2", "html"

    it "should publish a SASS file to CSS file",
      stu.test_url_type_ok "/example/server-generated-stylesheet-2", "css"

    it "should serve a Stylus file to CSS file",
      stu.test_url_type_ok "/example/server-generated-stylesheet", "css",
        """
  .example {
    font: 14px/1.5 Helvetica, arial, sans-serif;
  }
  .example #main {
    border: 1px solid #f00;
  }
        """

    it "should serve JSON data", stu.test_url_type_ok "/example/data.json",
      "application/json", """
  {
    "data": [ {
      "value": 123
    } ]
  }
        """

    it "should publish a client css",
      stu.test_url_type_ok "/media/style/default.css", "text/css"

    it "should publish literate doc",
      stu.test_url_type_ok "/doc/literate/", "html"

    
  if process.env.USER != 'travis' && stu.module_installed 'pm2'
    it "should publish a PM2 client",
      stu.test_url_type_ok "/proc/pm2.html", "text/html"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2/"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2"


  describe "has a Graphviz router for DOT diagram to PNG format", ->

    it "should render a PNG format", stu.test_url_type_ok \
        "/example/graphviz-binary-search-tree-graph.dot.png", "image/png"

    it "should redirect", stu.test_url_redirected \
        "/example/graphviz-binary-search-tree-graph.dot"


  describe "has an auto complete API", ->

    it "serves JSON",
      stu.test_url_type_ok "/Sitefile/core/auto", "application/json"

    it "serves valid auto-complete JSON, non-empty, has Sitefile routes", ->

      stu.load_schema 'ac_full', 'var/autocomplete-schema.json'
      validate_ac_json = stu.schema.ac_full
      url = stu.get_url()+"/Sitefile/core/auto"

      new Promise ( resolve, reject ) ->
        request.get url, ( err, res, body ) ->
          expect(err).be.null
          expect( res.statusMessage ).to.equal 'OK'

          data = JSON.parse body
          expect(data).to.not.be.empty

          v = validate_ac_json data
          expect(v).to.be.true

          k = _.findKey( data, [ 'label', '/index' ] )
          expect( data[k] ).to.eql {
            "label": "/index"
            "category": "File"
            "restype": "StaticPath"
            "router": "docutils.rst2html"
          }
          resolve()


  describe "and has local extension routes in example/routers", ->

    it "used by sf-example/default", stu.test_url_type_ok "/sf-example/default",
      "text", "Sitefile example"

    it "used by sf-example/data1", stu.test_url_type_ok "/sf-example/data1",
      "json", '{"sf-example":"dynamic"}'
      
    it "used by sf-example/data2", stu.test_url_type_ok "/sf-example/data2",
      "json", '{"sf-example":"static"}'


    it "(verify test failure)", stu.test_url_not_ok "/sf-example/no-such-route",
      /Cannot\ GET/


  it "(verify test failure)", stu.test_url_not_ok "/sf-example/no-such-route",
    /Cannot\ GET/


# Id: node-sitefile/0.0.7-dev test/mocha/Sitefile_yaml.coffee
