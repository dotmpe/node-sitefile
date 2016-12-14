
###
Boilerplate. Want to test serverside testing, clientside, and ways
to route serverside testing. See sitefile:doc/feature-testing.
###

expect = require('chai').expect
sitefile = require('../../lib/sitefile/sitefile')


describe "app", ->
  describe "sitefile", ->
    describe "base", ->
      it "should load", ->
        expect(sitefile).to.be.an "object"


