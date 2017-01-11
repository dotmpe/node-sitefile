_ = require 'lodash'
path = require 'path'

chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'
Ajv = require 'ajv'

ajv = new Ajv()

# FIXME failures on features/pm2 with Context...
#Function::property = ( prop, desc ) ->
#  unless "object" is typeof desc
#    throw new Error "Property #{prop} must be object, not #{desc}"
#  Object.defineProperty @prototype, prop, desc


class SitefileTestUtils
  constructor: ( @dir ) ->
    process.env.NODE_ENV = 'testing'
    @cwd = process.cwd()
    @server = {}
    @ctx = {}
    # JSON schema
    @schema = {}
    @schemaSrc = {}
    @schemaSrcData = {}

  env_browser: ->
    if process.env.USER is 'travis'
      return 'firefox'
    else
      return 'chrome'

  get_sitefile: ->
    lib = require '../lib/sitefile'
    if @dir
      process.chdir @dir
    sitefile = lib.new_context().sitefile
    process.chdir @cwd
    sitefile

  get_url: ->
    "http://localhost:#{@server.port}"

  before: ( done ) ->
    if not _.isEmpty @server
      throw new Error "Already initialized a server"
    @server = require '../bin/sitefile'
    if @dir
      process.chdir @dir
    [ @sf, @ctx, @proc ] = @server.run done

  after: ( done ) ->
    @server.proc.close()
    process.chdir @cwd
    done()

  # Get local site path
  req_url_ok: ( url, self = @, cb ) ->
    request.get self.get_url()+url, cb

  test_url_ok: ( url, self = @ ) ->
    ( done ) ->
      self.req_url_ok url, self, ( err, res, body ) ->
        self.expect_ok res
        done()

  test_url_redirected: ( url, self = @ ) ->
    ( done ) ->
      request.get {
        url: self.get_url()+url
        followRedirect: false
      }, ( err, res, body ) ->
        self.expect_redirected res
        done()

  test_url_redirects: ( from, to, self = @ ) ->
    ( done ) ->
      request.get from, ( err, res, body ) ->
        self.expect_redirected res
        self.expect_url self.get_url()+to
        done()

  test_url_type_ok: ( url, type = "html", content = null, self = @ ) ->
    ->
      new Promise ( resolve, reject ) ->
        request.get self.get_url()+url, ( err, res, body ) ->
          if err
            reject err
          self.expect_ok res
          if content
            expect( body.trim() ).to.equal content
          self.expect_content_type res, type
          resolve()

  expect_ok: ( res ) ->
    if res.statusMessage != 'OK'
      console.log res.body
    expect( res.statusMessage ).to.equal 'OK'
    expect( res.statusCode ).to.equal 200

  expect_redirected: ( res ) ->
    expect( res.statusCode ).to.equal 302

  expect_content_type: ( res, type ) ->
    expect( res ).has.ownProperty 'headers'
    expect( res.headers ).to.be.a 'object'
    expect( res.headers ).has.ownProperty 'content-type'
    expect( res.headers['content-type'] ).to.be.a "string"
    expect( res.headers['content-type'] ).to.contain type

  module_installed: ( name ) ->
    try
      mod = require name
      return true
    catch error
      if error.code != 'MODULE_NOT_FOUND'
        return false
      throw error

  req_json_file_valid: ( path, validator, valid=true ) ->
    new Promise ( resolve, reject ) ->
      data = require path
      try
        if validator data
          if valid then resolve()
          else reject(new Error("Validator should have passed: #{validator.errors}"))
        else
          if valid then reject(new Error("Validator should have failed"))
          else resolve(validator.errors)
      catch err
        reject(new Error("Validator exception: #{err}"))

  load_ajv_schema: ( name, filepath ) ->
    @schemaSrc[name] = path.join process.cwd(), filepath
    @schemaSrcData[name] = require @schemaSrc[name]
    if _.isEmpty @schemaSrcData[name]
      throw new Error "No data for #{name} (#{filepath})"
    @schema[name] = ajv.compile @schemaSrcData[name]



module.exports = {}

module.exports.ajv = ajv
module.exports.SitefileTestUtils = SitefileTestUtils

