# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee

_ = require 'lodash'
chai = require 'chai'
#chai.use require 'chai-as-promised'
expect = chai.expect
sewd = require 'selenium-webdriver'
browser = require 'selenium-webdriver/testing'
request = require 'request'
Promise = require 'bluebird'
yaml = require 'js-yaml'


lib = require '../../lib/sitefile'

tu = require './../test-utils'



describe "The local Sitefile.yaml serves the local documentation, and \
 doubles as an example for all handlers. Starting a server instance", ->


  stu = new tu.SitefileTestUtils()
  this.timeout 20000

  before stu.before.bind stu
  after stu.after.bind stu


  if stu.module_installed 'pm2'

    it "should publish a PM2 client",
      stu.test_url_type_ok "/proc/pm2.html", "text/html"

    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2/"
    it "should redirect for PM2 client", stu.test_url_redirected "/proc/pm2"

    it "should publish a PM2 app list JSON",
      stu.test_url_type_ok "/proc/pm2.json", "json"

    stu.load_ajv_schema 'pm2', 'var/pm2-list-schema.json'

    it "serves valid JSON", ->

      pm2_json_v = stu.schema.pm2
      url = stu.get_url()+"/proc/pm2.json"

      new Promise ( resolve, reject ) ->
        request.get url, ( err, res, body ) ->
          if err then reject err
          else
            expect( res.statusMessage ).to.equal 'OK'

            data = JSON.parse body
            expect(data).to.not.be.empty

            if not pm2_json_v data
              throw new Error '\n'+ yaml.dump pm2_json_v.errors

            resolve()


