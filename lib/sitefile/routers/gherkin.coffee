fs = require 'fs'
#path = require 'path'
#sitefile = require '../sitefile'
#_ = require 'lodash'

module.exports = ( ctx ) ->

  Gherkin = require 'gherkin'

  name: 'gherkin'
  label: 'HTML5 Sitefile Client prototype'
  usage: """
    gherkin:**/*.feature
  """

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        gherkin = fs.readFileSync rctx.res.path
        parser = new Gherkin.Parser()
        gherkinDocument = parser.parse String gherkin
        res.type 'json'
        res.write JSON.stringify gherkinDocument
        res.end()

    raw: ( rctx ) ->
      ( req, res ) ->
        gherkin = fs.readFileSync rctx.res.path
        res.type 'txt'
        res.write gherkin
        res.end()


