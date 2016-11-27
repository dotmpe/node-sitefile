'use strict';

module.exports = function(grunt) {

  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
      "package": {
        src: '*.json'
      },
      "examples": {
        src: [
          'example/**/*.json',
          'example/**/*.js'
        ]
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
        'test/**/*.coffee',
        'example/**/*.coffee'
      ]
    },

    yamllint: {
      all: {
        src: [
          'Sitefile.yaml',
          'package.yaml'
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
    },

		docco: {
			debug: {
				src: ['lib/**/*.coffee'],
				options: {
					output: 'build/docs/docco/'
				}
			}
		},

		sass: {
		  options: {
		    sourceMap: true
      },
      dist: {
        files: {
          'build/styles/default.css': 'lib/sitefile/style/default.sass'
        }
      }
    },
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

  grunt.registerTask('default', [
    'lint',
    'test'
  ]);

  grunt.registerTask('build', [
    'sass',
    'docco'
  ]);
};
