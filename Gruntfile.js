'use strict';

var fs = require('fs');
var path = require('path');

var webpack = require('webpack');


var nodeModules = {};
fs.readdirSync('node_modules')
  .filter(function(x) {
    return ['.bin'].indexOf(x) === -1;
  })
  .forEach(function(mod) {
    nodeModules[mod] = 'commonjs ' + mod;
  });


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
    },

    webpack: {
      server: {
        entry: [ './bin/sitefile.coffee' ],
        target: 'node',
        output: {
          path: path.join(__dirname, 'dist'),
          filename: 'sitefile.js',
          libraryTarget: "commonjs2",
          library: "sitefile_cli"
        },
        module: {
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
            }
          ]
        },
        externals: nodeModules,
        plugins: [
          new webpack.IgnorePlugin(/^(markdown|pug|pug-runtime|stylus|pm2|pmx|knex)$/),
          new webpack.IgnorePlugin(/\.(css|less)$/),
          new webpack.BannerPlugin('require("source-map-support").install();',
                                   { raw: true, entryOnly: false }),
        ],
        resolve: {
          extensions: [
            '', '.coffee', '.js', '.json', '.pug'
          ]
        },
        devtool: 'sourcemap',
      }
    },

    jsdoc : {
        dist : {
            src: ['dist/*.js'],
            options: {
                destination: 'build/docs/jsdoc/'
            }
        }
    },

		docco: {
			debug: {
				src: ['lib/**/*.coffee'],
				options: {
					output: 'build/docs/docco/'
				}
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

  grunt.registerTask('default', [
    'lint',
    'test'
  ]);

  grunt.registerTask('build', [
    'docco',
    'webpack',
    'jsdoc'
  ]);

};
