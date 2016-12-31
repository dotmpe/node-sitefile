

webpack = require 'webpack'


module.exports = ( grunt ) ->

  # auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    jshint:
      package:
        options:
          jshintrc: '.jshintrc'
        src: [
          '*.json'
          'gulpfile.js'
        ]

      examples:
        options:
          jshintrc: '.jshintrc-client'
        src: [
          'example/**/*.json'
          'example/**/*.js'
        ]

    coffeelint:
      options:
        configFile: '.coffeelint.json'
      gruntfile: [ 'Gruntfile.coffee' ]
      app: [
        'bin/*.coffee'
        'lib/**/*.coffee'
        'config/**/*.coffee'
        'test/**/*.coffee'
        'example/**/*.coffee'
      ]

    yamllint:
      all: [
        'Sitefile.yaml'
        'package.yaml'
        '**/*.meta'
      ]

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
          captureFile: 'mocha.out'
          quiet: false
          clearRequireCache: false # do explicitly as needed
        src: ['test/mocha/*.coffee']

    webpack:
      client:
        entry: './lib/sitefile/client/lib/sf-v0'
        devtool: 'sourcemap'
        output:
          filename: 'build/client/sf-v0.js'
          library: "sitefile_client"
        module:
          loaders: [
            {
              test: /\.js$/,
              exclude: /node_modules/,
              loaders: ['babel']
            },
            {
              test: /\.coffee$/,
              exclude: /node_modules/,
              loader: "coffee"
            },
            {
              test: /\.json$/,
              loader: "json"
            },
            {
              test: /\.pug$/,
              exclude: /node_modules/,
              loader: "pug"
            },
          ]
        plugins: [
          new webpack.IgnorePlugin(/^(markdown|pug|pug-runtime|stylus|pm2|pmx|knex)$/),
          new webpack.IgnorePlugin(/\.(css|less)$/),
          new webpack.BannerPlugin('require("source-map-support").install();',
                                   { raw: true, entryOnly: false }),
        ],
        #externals: nodeModules,
        resolve:
          extensions: [
            '', '.coffee', '.js', '.json', '.pug'
          ]

    docco:
      debug:
        src: [
          'lib/**/*.coffee'
          'test/**/*.coffee'
          'example/**/*.coffee'
          'example/**/*.js'
        ]
        options:
          output: 'build/docs/docco/'

    sass:
      options:
        outputStyle: 'expanded'
        sourceMap: true
      dist:
        files:
          'build/style/default.css': 'lib/sitefile/style/default.sass'

    exec:
      check_version:
        cmd: "git-versioning check"
      check_branch_docs:
        cmd: "sh ./tools/check-branch-docs.sh"
      gulp_dist_build:
        cmd: "gulp server-build"
      spec_update:
        cmd: "sh ./tools/update-spec.sh"
      compile_jsonary:
        cmd: 'cd public/components/jsonary; test -e jsonary.js || php jsonary.js.php'

    pkg: grunt.file.readJSON 'package.json'


  # Static analysis of source files
  grunt.registerTask 'lint', [
    'coffeelint'
    'jshint'
    'yamllint'
  ]

  grunt.registerTask 'check', [
    'exec:check_branch_docs'
    'exec:check_version'
    'lint'
  ]

  # Tests server-side
  grunt.registerTask 'test', [
    'mochaTest:test'
  ]

  # Everything
  grunt.registerTask 'default', [
    'lint'
    'test'
  ]
  
  grunt.registerTask 'build', [ 'build-dev' ]

  # Documentation artefacts, some intial publishing
  grunt.registerTask 'build-dev', [
    'exec:compile_jsonary'
    'build-test'
    'exec:gulp_dist_build'
    'exec:spec_update'
  ]

  grunt.registerTask 'client', [
    'sass:dist'
    # XXX: using rjs cs client for now 'webpack:client'
  ]

  grunt.registerTask 'build-test', [
    'client'
    'docco:debug'
  ]

