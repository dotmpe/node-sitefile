_ = require 'lodash'
path = require 'path'

chai = require 'chai'
expect = chai.expect
request = require 'request'
#request_promise = require 'request-promise'
Promise = require 'bluebird'
Ajv = require 'ajv'


ajv = new Ajv()

# FIXME failures on features/pm2 with Context...
#Function::property = ( prop, desc ) ->
#  unless "object" is typeof desc
#    throw new Error "Property #{prop} must be object, not #{desc}"
#  Object.defineProperty @prototype, prop, desc

version = "0.0.7-dev" # node-sitefile


class SitefileTestUtils
  constructor: ( @dir ) ->
    if not process.env.NODE_ENV
      throw new Error "NODE_ENV required for testing"
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
    sitefile = lib.prepare_context().sitefile
    process.chdir @cwd
    sitefile

  get_url: ->
    "http://#{@server.host}:#{@server.port}"

  before: ( done ) ->
    if not _.isEmpty @server
      throw new Error "Already initialized a server"
    @server = require '../bin/sitefile-cli'
    if @dir
      process.chdir @dir
    self = @
    cb = ->
      console.log 'Test instance', self.ctx.version, \
        'started at', self.ctx.site.port
      #console.log 'SFPATH', self.ctx.paths.packages, 'PWD', self.ctx.sfdir
      done()
    [ @sf, @ctx, @proc ] = @server.run_main cb, {
      '--bwc': version, '--verbose': false
    }, {
      sfdir: process.cwd()
    }

  after: ( done ) ->
    @server.proc.close()
    process.chdir @cwd
    done()

  # Get local site path
  req_url_ok: ( url, self = @, cb ) ->
    request.get self.get_url()+url, cb

  test_url_ok: ( url, self=@, count=3 ) ->
    ->
      Promise.each ( i for i in [1..count] ), ->
        new Promise ( resolve, reject ) ->
          self.req_url_ok url, self, ( err, res, body ) ->
            self.expect_ok res
            expect( body.trim() ).to.not.match /.*Error:.*/
            resolve()

  test_url_redirected: ( url, self=@, count=3 ) ->
    ->
      Promise.each ( i for i in [1..count] ), ->
        new Promise ( resolve, reject ) ->
          request.get {
            url: self.get_url()+url
            followRedirect: false
          }, ( err, res, body ) ->
            expect(err).be.null
            self.expect_redirected res
            resolve()

  test_url_redirects: ( from, to, self=@, count=3 ) ->
    ->
      Promise.each ( i for i in [1..count] ), ->
        new Promise ( resolve, reject ) ->
          request.get from, ( err, res, body ) ->
            expect(err).be.null
            self.expect_redirected res
            self.expect_url self.get_url()+to
            expect( body.trim() ).to.not.match /^[A-Za-z]*Error:.*/
            resolve()

  # Test at least 3 times to verify positive pattern
  test_url_type_ok: ( url, type="html", content=null, self=@, count=3 ) ->
    ->
      Promise.each ( i for i in [1..count] ), ->
        new Promise ( resolve, reject ) ->
          request.get self.get_url()+url, ( err, res, body ) ->
            expect(err).be.null
            self.expect_ok res
            self.expect_content_type res, type
            if content
              if content instanceof RegExp
                expect( body.trim() ).to.match content
              else expect( body.trim() ).to.equal content
            else expect( body.trim() ).to.not.match /^[A-Za-z]*Error:.*/
            resolve [i, url]

  # negative test too
  test_url_not_ok: ( url, content=null, self=@, count=3 ) ->
    ->
      Promise.each ( i for i in [1..count] ), ->
        new Promise ( resolve, reject ) ->
          request.get self.get_url()+url, ( err, res, body ) ->
            expect( res.statusMessage ).to.not.equal 'OK'
            expect( res.statusCode ).to.not.equal 200
            if content
              if content instanceof RegExp
                expect( body.trim() ).to.match content
              else expect( body.trim() ).to.equal content
            else expect( body.trim() ).to.not.match /^[A-Za-z]*Error:.*/
            resolve [i, url]

  expect_ok: ( res ) ->
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
          else reject path
        else
          if valid then reject path
          else resolve()
      catch err
        reject [ path, err ]

  load_schema: ( name, filepath ) ->
    @schemaSrc[name] = path.join @cwd, filepath
    @schemaSrcData[name] = require @schemaSrc[name]
    if _.isEmpty @schemaSrcData[name]
      throw new Error "No data for #{name} (#{filepath})"
    @schema[name] = ajv.compile @schemaSrcData[name]


module.exports = {}

module.exports.SitefileTestUtils = SitefileTestUtils
