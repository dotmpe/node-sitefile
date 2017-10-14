

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
          colors: true
          require: 'coffee-script/register'
          captureFile: 'mocha.out'
          quiet: false
          noFail: true # turn of for stable release again
          clearRequireCache: false # do explicitly as needed
        src: ['test/mocha/*.coffee']

      tap:
        options:
          reporter: 'TAP'
          colors: true
          require: 'coffee-script/register'
          captureFile: 'mocha-results.tap'
          quiet: false
          noFail: true # turn of for stable release again
          clearRequireCache: false # do explicitly as needed
        src: ['test/mocha/*.coffee']

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
      doc_defaults_docco_refs:
        cmd: "sh ./tools/generate-docco-rst-refs.sh > doc/.defaults-docco.rst"

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
    'literate'
    'exec:gulp_dist_build'
    'exec:spec_update'
  ]

  grunt.registerTask 'literate', [
    'exec:doc_defaults_docco_refs'
    'docco:debug'
  ]

  grunt.registerTask 'client', [
    'sass:dist'
  ]

  grunt.registerTask 'build-test', [
    'client'
    'docco:debug'
  ]

