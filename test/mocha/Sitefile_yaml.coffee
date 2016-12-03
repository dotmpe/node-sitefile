# Id: node-sitefile/0.0.5-dev test/mocha/Sitefile_yaml.coffee
chai = require 'chai'
expect = chai.expect
request = require 'request'
Promise = require 'bluebird'

lib = require '../../lib/sitefile'


describe "The local Sitefile.yaml serves the local documentation, and
doubles is an example for all handlers. ", ->

  this.timeout 6000


  it "should serve its own ReadMe", ( done ) ->

    url = "http://localhost:#{server.port}/ReadMe"
    request.get url, ( err, res, body ) ->
      if res.statusMessage != 'OK'
        console.log body
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
      if res.statusMessage != 'OK'
        console.log body
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a CoffeeScript file to Javascript", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-javascript"
    request.get url, ( err, res, body ) ->
      if res.statusMessage != 'OK'
        console.log body
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a Pug file to HTML", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-page"
    request.get url, ( err, res, body ) ->
      if res.statusMessage != 'OK'
        console.log body
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve a Stylus file to CSS file", ( done ) ->

    url = "http://localhost:#{server.port}/example/server-generated-stylesheet"
    request.get url, ( err, res, body ) ->
      if res.statusMessage != 'OK'
        console.log body
      expect( res.statusMessage ).to.equal 'OK'
      expect( res.statusCode ).to.equal 200
      done()


  it "should serve routes for a local extension router example", ( done ) ->

    tasks = [
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{server.port}/sf-example/default"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          expect( body ).to.equal "Sitefile example"
          resolve()
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{server.port}/sf-example/data1"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          data = JSON.parse body
          expect( data['sf-example'] ).to.equal 'dynamic'
          resolve()
      new Promise ( resolve, reject ) ->
        url = "http://localhost:#{server.port}/sf-example/data2"
        request.get url, ( err, res, body ) ->
          if res.statusMessage != 'OK'
            console.log body
          expect( res.statusMessage ).to.equal 'OK'
          expect( res.statusCode ).to.equal 200
          data = JSON.parse body
          expect( data['sf-example'] ).to.equal 'static'
          resolve()
    ]
    Promise.all( tasks ).then -> done()

    null


  server = null

  process.env.NODE_ENV = 'testing'

  before ( done ) ->
    server = require '../../bin/sitefile'
    server.run done

  after ( done ) ->
    server.proc.close()
    done()



