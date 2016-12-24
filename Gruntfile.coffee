'use strict'


module.exports = ( grunt ) ->

  # auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    jshint:
      gulpfile:
        options:
          jshintrc: '.jshintrc'
        src: [ 'gulpfile.js' ]

      package:
        options:
          jshintrc: '.jshintrc'
        src: [ '*.json' ]

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
    'webpack:client'
  ]

  grunt.registerTask 'build-test', [
    'client'
    'docco:debug'
  ]

