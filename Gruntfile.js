'use strict';

module.exports = function(grunt) {

  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    exec: {
        compile_jsonary: {
            cmd: 'cd public/components/jsonary; test -e jsonary.js || php jsonary.js.php'
        }
    },

    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
      "package": {
        src: 'package.json'
      }
    },

    coffeelint: {
      options: {
        configFile: '.coffeelint.json'
      },
      app: [
        'bin/*.coffee',
        'lib/**/*.coffee',
        'config/**/*.coffee',
        'test/**/*.coffee'
      ]
    },

    yamllint: {
      all: {
        src: [
          'Sitefile.yaml'
        ]
      }
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script/register',
          captureFile: 'mocha.out',
          quiet: false,
          clearRequireCache: false
        },
        src: ['test/mocha/*.coffee']
      }
    }

  });

  // auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt);

  grunt.registerTask('lint', [
    'coffeelint',
    'jshint',
    'yamllint'
  ]);

  grunt.registerTask('test', [
    'mochaTest'
  ]);

  grunt.registerTask('prep-site', [
    'exec:compile_jsonary',
  ]);

  grunt.registerTask('default', [
    'lint',
    'test'
  ]);

};
