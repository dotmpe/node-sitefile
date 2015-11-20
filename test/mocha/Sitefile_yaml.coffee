# Id: node-sitefile/0.0.4-f-client test/mocha/Sitefile_yaml.coffee
chai = require 'chai'
expect = chai.expect
request = require 'request'

lib = require '../../lib/sitefile'


describe "The local Sitefile.yaml serves the local documentation, and
doubles is an example for all handlers. ", ->

  this.timeout 6000

  # FIXME: should abstract test to more simpler format

  it "should serve its own ReadMe", ( done ) ->

    url = "http://localhost:#{server.port}/ReadMe"
    request.get url, ( err, res, body ) ->
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve its own ReadMe and redirect ReadMe.rst", ( done ) ->

    req =
      url: "http://localhost:#{server.port}/ReadMe.rst"
      followRedirect: false
    request.get req, ( err, res, body ) ->
      expect( res.statusCode ).to.equal 302
      done()


  it "should serve its own ChangeLog", ( done ) ->

    url = "http://localhost:#{server.port}/ChangeLog"
    request.get url, ( err, res, body ) ->
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a Jade file to Javascript", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-javascript"
    request.get url, ( err, res, body ) ->
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a Markdown file to HTML", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-page"
    request.get url, ( err, res, body ) ->
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a Stylus file to CSS file", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-stylesheet"
    request.get url, ( err, res, body ) ->
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()



  server = null


  before ( done ) ->
    server = require '../../bin/sitefile'
    server.run done

  after ( done ) ->
    server.proc.close()
    done()



