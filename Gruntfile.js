'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
    },
    coffeelint: {
      options: {
        configFile: '.coffeelint.json'
      },
      app: [ 'bin/*.coffee', 'src/**/*.coffee', 'config/**/*.coffee' ]
    },
    //nodeunit: {
    //  files: ['test/nodeunit/**/*.coffee'],
    //},
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      //lib: {
      //  files: '<%= jshint.lib.src %>',
      //  tasks: ['jshint:lib', 'nodeunit']
      //},
      test: {
        files: '<%= jshint.test.src %>',
        tasks: [ 'jshint:test' ]
      },
    },
  });

  // auto load grunt contrib tasks from package.json
  require('load-grunt-tasks')(grunt);

  // auto load parts from grunt/
  //require('load-grunt-config')(grunt);

  // Default task.
  grunt.registerTask('test', [ ]);
  grunt.registerTask('lint', [ 'coffeelint', 'jshint' ]);
  grunt.registerTask('default', [ 'test', 'lint' ]);
};
