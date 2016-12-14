
chai = require 'chai'
expect = chai.expect
request = require 'request'


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

  #@property 'url',
  #  get: @get_url
    
  get_url: ->
    "http://localhost:#{@server.port}"

  before: ( done ) ->
    @server = require '../bin/sitefile'
    if @dir
      process.chdir @dir
    [ @sf, @ctx, @proc ] =@server.run done

  after: ( done ) ->
    @server.proc.close()
    process.chdir @cwd
    done()

  test_url_ok: ( url, self = @ ) ->
    ( done ) ->
      request.get self.get_url()+url, ( err, res, body ) ->
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
    ( done ) ->
      request.get self.get_url()+url, ( err, res, body ) ->
        self.expect_ok res
        if content
          expect( body.trim() ).to.equal content
        self.expect_content_type res, type
        done()

  expect_ok: ( res ) ->
    if res.statusMessage != 'OK'
      console.log res.body
    expect( res.statusMessage ).to.equal 'OK'
    expect( res.statusCode ).to.equal 200

  expect_redirected: ( res ) ->
    expect( res.statusCode ).to.equal 302

  expect_url: ( res ) ->

  expect_content_type: ( res, type ) ->
    expect( res ).has.ownProperty 'headers'
    expect( res.headers ).to.be.a 'object'
    expect( res.headers ).has.ownProperty 'content-type'
    expect( res.headers['content-type'] ).to.be.a "string"
    expect( res.headers['content-type'] ).to.contain type



module.exports = {}

module.exports.SitefileTestUtils = SitefileTestUtils

