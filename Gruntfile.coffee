'use strict'


module.exports = ( grunt ) ->

  # auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    jshint:
      options:
        jshintrc: '.jshintrc'
      gulpfile: [ 'gulpfile.js' ]
      package: [ '*.json' ]
      examples: [
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
      ]

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
          captureFile: 'mocha.out'
          quiet: false
          clearRequireCache: false
        src: ['test/mocha/*.coffee']

    webpack:
      client:
        entry: './lib/sitefile/client/default'
        devtool: 'sourcemap'
        output:
          filename: 'build/client/default.js'
          library: "sitefile_default_client"
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

    docco:
      debug:
        src: ['lib/**/*.coffee']
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
    'mochaTest'
  ]

  # Everything
  grunt.registerTask 'default', [
    'lint'
    'test'
  ]

  # Documentation artefacts, some intial publishing
  grunt.registerTask 'build', [
    'sass'
    'docco'
    'webpack'
    'exec:gulp_dist_build'
  ]

