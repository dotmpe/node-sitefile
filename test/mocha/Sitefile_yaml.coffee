# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee

_ = require 'lodash'
fs = require 'fs'
chai = require 'chai'
#chai.use require 'chai-as-promised'
expect = chai.expect
yaml = require 'js-yaml'
sewd = require 'selenium-webdriver'
browser = require 'selenium-webdriver/testing'
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


  stu.load_ajv_schema 'sf', 'var/sitefile-context.yaml#/definitions/sitefile'

  it "parses the Sitefile", ->
   
    fn = 'Sitefile.yaml'
    fp = fs.readFileSync fn, 'utf8'
    data = yaml.safeLoad fp
    if not stu.schema.sf data
      throw new Error '\n'+ yaml.dump stu.schema.sf.errors
    

  describe "serves its own ReadMe, ChangeLog", ->

    it "without problems", stu.test_url_ok "/ReadMe"

    it "redirect ReadMe.rst", stu.test_url_redirected "/ReadMe.rst"

    it "redirect root", stu.test_url_redirected "/"

    it "serve the correct type", stu.test_url_type_ok "/ReadMe", "html"

    it "should serve its own ChangeLog", stu.test_url_ok "/ChangeLog"

  
  describe "has various other types", ->

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

    it "should serve JSON data", stu.test_url_type_ok \
        "/example/data.json", "application/json", """
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


  ###
  XXX: now using requirejs client

  it "should publish a client JS",
    stu.test_url_type_ok \
      "/media/script/sitefile-client.js", "application/javascript"

  ###


  describe "has a Graphviz router for DOT diagram to PNG format", ->

    it "should render a PNG format", stu.test_url_type_ok \
        "/example/graphviz-binary-search-tree-graph.dot.png", "image/png"

    it "should redirect", stu.test_url_redirected \
        "/example/graphviz-binary-search-tree-graph.dot"


  describe "has an auto complete API", ->

    it "serves JSON", stu.test_url_type_ok \
      "/Sitefile/core/auto", "application/json"

    it "serves valid auto-complete JSON, non-empty, has Sitefile routes", ->

      stu.load_ajv_schema 'ac_full', 'var/autocomplete-schema.json'
      validate_ac_json = stu.schema.ac_full
      url = stu.get_url()+"/Sitefile/core/auto"

      new Promise ( resolve, reject ) ->
        request.get url, ( err, res, body ) ->
          if err then reject err
          else
            expect( res.statusMessage ).to.equal 'OK'

            data = JSON.parse body
            expect(data).to.not.be.empty

            v = validate_ac_json data
            expect(v).to.be.true

            k = _.findKey( data, [ 'label', '/ReadMe' ] )
            expect( data[k] ).to.eql {
              "label": "/ReadMe"
              "category": "File"
              "restype": "StaticPath"
              "router": "du.rst2html"
            }

            resolve()


  describe "and has routes for local extensions in example/routers/..", ->

    it "loading some handlers of sf-example", ->
      [
        new Promise ( resolve, reject ) ->
          url = "http://localhost:#{stu.server.port}/sf-example/default"
          request.get url, ( err, res, body ) ->
            if err then reject err
            else
              if res.statusMessage != 'OK' then console.log body
              expect( res.statusMessage ).to.equal 'OK'
              expect( res.statusCode ).to.equal 200
              expect( body ).to.equal "Sitefile example"
              resolve()
        new Promise ( resolve, reject ) ->
          url = "http://localhost:#{stu.server.port}/sf-example/data1"
          request.get url, ( err, res, body ) ->
            if err then reject err
            else
              if res.statusMessage != 'OK' then console.log body
              expect( res.statusMessage ).to.equal 'OK'
              expect( res.statusCode ).to.equal 200
              data = JSON.parse body
              expect( data['sf-example'] ).to.equal 'dynamic'
              resolve()
        new Promise ( resolve, reject ) ->
          url = "http://localhost:#{stu.server.port}/sf-example/data2"
          request.get url, ( err, res, body ) ->
            if err then reject err
            else
              if res.statusMessage != 'OK' then console.log body
              expect( res.statusMessage ).to.equal 'OK'
              expect( res.statusCode ).to.equal 200
              data = JSON.parse body
              expect( data['sf-example'] ).to.equal 'static'
              resolve()
      ]



