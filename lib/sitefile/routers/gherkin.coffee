fs = require 'fs'
#path = require 'path'
glob = require 'glob'
#sitefile = require '../sitefile'
_ = require 'lodash'

module.exports = ( ctx ) ->

  Gherkin = require 'gherkin'

  name: 'gherkin'
  label: 'HTML5 Sitefile Client prototype'
  usage: """
    gherkin:**/*.feature
  """

  lib:
    parse: ( path ) ->
      gherkin = fs.readFileSync path
      parser = new Gherkin.Parser()
      gherkinDoc = parser.parse String gherkin
      gherkinDoc.src = path
      gherkinDoc

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        gherkinDoc = ctx._routers.get('gherkin').lib.parse rctx.res.path
        res.type 'json'
        res.write JSON.stringify gherkinDoc
        res.end()

    steps: ( rctx ) ->
      res: data: ->
        docs = []
        features = _.flattenDeep [
          glob.sync p for p, i in rctx.route.spec.split ',' ]
        for p in features
          docs.push ctx._routers.get('gherkin').lib.parse p
        docs

    raw: ( rctx ) ->
      ( req, res ) ->
        gherkin = fs.readFileSync rctx.res.path
        res.type 'txt'
        res.write gherkin
        res.end()


