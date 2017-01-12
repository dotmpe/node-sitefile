_ = require 'lodash'
fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'



module.exports = ( ctx ) ->

  
  try
    Mocha = require 'mocha'
  catch err
    if err.code == 'MODULE_NOT_FOUND'
      return {}
    throw err


  name: "mocha"
  usage: """
    """

  auto_export:
    route:
      _mocha: "mocha:**/*.mocha"
      "vendor/mocha.js": "static:node_modules/mocha/mocha.js"
      "vendor/chai.js": "static:node_modules/chai/chai.js"
      "vendor/sinon.js": "static:node_modules/sinon/pkg/sinon.js"
    
  defaults:
    default: 'auto'
    global:
      'test-all':
        'import-query': true # combine all query params onto rctx.route.options
        options:
          dir: 'test/mocha'
          reporter: 'json-stream'
          extension: '.js'
          suffix: '_test'
      test:
        query:
          dir: 'test/mocha'
          reporter: 'json-stream'
          extension: '.js'
          suffix: '_test'

      client:
        route:
          params: {}
          query:
            suffix: '_test'
          options:
            scripts: []
            stylesheets: []
            pug:
              format: 'html'
              compile:
                pretty: false
                debug: false
                compileDebug: false
                globals: []

  generate:
    auto: ( rctx ) ->

    "test-all": ( rctx ) ->
      """
      Work in progress. Need DI. Reporters are not very nice, see Mocha #1457.
      See sitefile:doc/feature-testing
      """
      ( req, res ) ->
        opts = rctx.req_opts rctx, req

        # Initialize
        mocha = new Mocha()
        testcases = fs.readdirSync( opts.dir ).filter ( file ) ->
          return file.endswith opts.extension
        for testcase in testcases
          testcasepath = path.join ctx.cwd, testcases
          delete require.cache[testcasepath+req.opts.extension]
          mocha.addFile testcasepath


    test: ( rctx ) ->
      ( req, res ) ->
        # Parameterization
        query = _.defaultsDeep req.query, rctx.route.query
        #params = _.defaultsDeep req.params, rctx.route.params
        # Test file
        testpath = path.join ctx.cwd, req.params[0]
        dud = testpath.replace req.query.extension, ''
        testcase = dud+req.query.suffix
        # Initialize
        mocha = new Mocha()
        if testcase+req.query.extension of require.cache
          delete require.cache[testcase+req.query.extension]
        mocha.addFile testcase
        # XXX: hardcoded deps
        global.chai = require 'chai'
        global.Cow = require(dud).Cow
        # Execute
        output = ''
        write = process.stdout.write
        # XXX: hijack stdout temporarily
        process.stdout.write = (str) ->
          output += str
        runner = mocha.reporter(query.reporter).run ( failures ) ->
          # XXX: restores stdout temporarily here
          process.stdout.write = write
          delete global.Cow
          delete global.chai
          res.type "txt"
          if failures
            res.status 400
          res.write output
          res.end()

    client: ( rctx ) ->
      pug = ctx._routers.get 'pug'
      ( req, res ) ->

        # Test file
        dud = path.join ctx.config.base, req.params[0]

        # Suffix to test spec
        query = _.defaultsDeep req.query, rctx.route.query

        params = _.defaultsDeep req.params, rctx.route.params

        pugOpts = _.defaultsDeep rctx.route.pug, {
          tpl: './lib/sitefile/routers/mocha.pug'
          merge:
            ref: rctx.res.ref
            route: rctx.route
            query: query
            params: params
            options: rctx.route.options
            context: rctx

            test_object: dud
            test_file: dud.replace('.js', req.query.suffix+'.js')
        }

        res.write pug.compile pugOpts
        res.end()


