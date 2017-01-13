# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee

_ = require 'lodash'
chai = require 'chai'
expect = chai.expect

request = require 'request'
Promise = require 'bluebird'


tu = require './../test-utils'



describe "The local Sitefile.yaml serves the local documentation, and \
 doubles as an example for all handlers. The server has a PM2 router that", ->

  stu = new tu.SitefileTestUtils()
  this.timeout 20000
  if stu.module_installed 'pm2'
    before stu.before.bind stu
    after stu.after.bind stu
  else
    before ->
      this.skip()

  it "should publish a HTML client listing or detailing processes",
    stu.test_url_type_ok "/proc/pm2.html", "text/html"

  it "and redirect for PM2 client (I)", stu.test_url_redirected "/proc/pm2/"
  it "and redirect for PM2 client (II)", stu.test_url_redirected "/proc/pm2"


  it "should publish a JSON list of running applications",
    stu.test_url_type_ok "/proc/pm2.json", "json"

  it "and the list should  fit a known JSON schema.", ->

    stu.load_ajv_schema 'pm2', 'var/pm2-list-schema.json'
    validate_pm2_json = stu.schema.pm2

    url = stu.get_url()+"/proc/pm2.json"

    new Promise ( resolve, reject ) ->
      request.get url, ( err, res, body ) ->
        if err then reject err
        else
          expect( res.statusMessage ).to.equal 'OK'

          data = JSON.parse body
          expect(data).to.not.be.empty

          expect(validate_pm2_json data).to.be.true

          resolve()


