

webpack = require 'webpack'

path = require 'path'


module.exports = ( grunt ) ->

  # auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    jshint:

      all:
        options:
          jshintrc: '.jshintrc'
        src: [
          '*.json'
          'gulpfile-old.js'
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

    coffee:
      app:
        expand: true
        flatten: true
        cwd: "#{__dirname}/lib/sitefile/routers/app-0"
        src: [
           "*.coffee"
        ],
        dest: 'dist/app-0'
        ext: '.js'


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
          new webpack.IgnorePlugin(
            /^(markdown|pug|pug-runtime|stylus|pm2|pmx|knex)$/)
          new webpack.IgnorePlugin(/\.(css|less)$/)
          new webpack.IgnorePlugin(/^cs/)
          new webpack.BannerPlugin(
            'require("source-map-support").install();',
                                   { raw: true, entryOnly: false })
        ],
        #externals: nodeModules
        resolve:
          extensions: [
            '', '.coffee', '.js', '.json', '.pug'
          ]

      #  XXX server build?
      server:
        entry: './bin/sitefile.coffee'
        devtool: 'sourcemap'
        output:
          path: path.join __dirname, 'dist'
          filename: 'sitefile.js'
          libraryTarget: "commonjs2"
          library: "sitefile_cli"
        resolve:
          extensions: [
            '', '.coffee', '.js', '.json', '.pug'
          ]

      app:
        entry: './lib/sitefile/client/app-0'
        devtool: 'sourcemap'
        output:
          filename: 'dist/app-0/main.js'
          library: "sitefile_prototype"
        module:
          loaders: [
            #  XXX babel?
            # {
            #   test: /\.js$/,
            #   exclude: /node_modules/,
            #   loaders: ['babel']
            # },
          ]
        resolve:
          extensions: [ '', '.js' ]



    jsdoc:
      dist:
        src: [
          'build/client/*.js'
        ]
        options:
          destination: 'build/docs/jsdoc/'



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
      app:
        files:
          'dist/app-0.css': 'lib/sitefile/routers/app-0/default.sass'

    exec:
      check_version:
        cmd: "git-versioning check"
      check_branch_docs:
        cmd: "sh ./tools/check-branch-docs.sh"
      gulp_dist_build:
        cmd: "gulp server-build"
      spec_update:
        cmd: "sh ./tools/update-spec.sh"

    pkg: grunt.file.readJSON 'package.json'


  # Static analysis of source files
  grunt.registerTask 'lint', [
    'coffeelint'
    'jshint:all'
    'jshint:examples'
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
    'build-test'
    'exec:gulp_dist_build'
    'exec:spec_update'
  ]

  grunt.registerTask 'client', [
    'sass:dist'
    # XXX: using rjs cs client for now
    'webpack:client'
  ]

  grunt.registerTask 'app', [
    'sass:app'
    'webpack:app'
    'coffee:app'
  ]

  grunt.registerTask 'build-test', [
    'client'
    'app'
    'jsdoc:dist'
    'docco:debug'
  ]

