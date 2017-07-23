
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


  describe "has a CDN-redirection router instance at vendor/", ->

    it "should serve require.js", stu.test_url_type_ok \
        "/vendor/require.js", "application/javascript"

    it "should serve coffee-script.js", stu.test_url_type_ok \
        "/vendor/coffee-script.js", "application/javascript"

    it "should serve bootstrap.js", stu.test_url_type_ok \
        "/vendor/bootstrap.js", "application/javascript"

    it "should serve bootstrap.css", stu.test_url_type_ok \
        "/vendor/bootstrap.css", "text/css"

    it "should serve bootstrap-theme.css", stu.test_url_type_ok \
        "/vendor/bootstrap-theme.css", "text/css"

    it "should serve jquery.js", stu.test_url_type_ok \
        "/vendor/jquery.js", "application/javascript"

    it "should serve jquery-ui.js", stu.test_url_type_ok \
        "/vendor/jquery-ui.js", "application/javascript"

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


