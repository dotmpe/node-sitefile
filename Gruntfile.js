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

		webpack: {
			client: {
				entry: './lib/sitefile/client/default' ,
				devtool: 'sourcemap',
				output: {
					filename: 'build/client/default.js',
					library: "sitefile_default_client"
				},
				module: {
					loaders: [
					  // XXX babel?
						//{
						//	test: /\.js$/,
						//	exclude: /node_modules/,
						//	loaders: ['babel']
						//},
					]
				},
				resolve: {
					extensions: [
						'', '.js'
					]
				},
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
				outputStyle: 'expanded',
				sourceMap: true,
			},
			dist: {
				files: {
					'build/style/default.css': 'lib/sitefile/style/default.sass'
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

	grunt.registerTask('prep-site', [
		'exec:compile_jsonary',
	]);

	grunt.registerTask('default', [
		'lint',
		'test'
	]);

	grunt.registerTask('build', [
		'exec:compile_jsonary',
		'sass',
		'docco',
		'webpack'
	]);
};
