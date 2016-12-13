
chai = require 'chai'
expect = chai.expect
request = require 'request'


Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class SitefileTestUtils
  constructor: ( @server )->

  @property 'url',
    get: ->
      "http://localhost:#{@server.port}"

  test_url_ok: ( url, self = @ ) ->
    ( done ) ->
      request.get self.url+url, ( err, res, body ) ->
        self.expect_ok res
        done()

  test_url_redirected: ( url, self = @ ) ->
    ( done ) ->
      request.get {
        url: self.url+url
        followRedirect: false
      }, ( err, res, body ) ->
        self.expect_redirected res
        done()

  test_url_redirects: ( from, to, self = @ ) ->
    ( done ) ->
      request.get from, ( err, res, body ) ->
        self.expect_redirected res
        self.expect_url self.url+to
        done()

  test_url_type_ok: ( url, type = "html", content = null, self = @ ) ->
    ( done ) ->
      request.get self.url+url, ( err, res, body ) ->
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

