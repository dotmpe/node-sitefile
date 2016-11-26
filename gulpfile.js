var gulp = require('gulp');
var webpack = require('webpack');
var path = require('path');
var fs = require('fs');
var header = require('gulp-header');
var chmod = require('gulp-chmod');
var rename = require('gulp-rename');

var nodeModules = {};
fs.readdirSync('node_modules')
  .filter(function(x) {
    return ['.bin'].indexOf(x) === -1;
  })
  .forEach(function(mod) {
    nodeModules[mod] = 'commonjs ' + mod;
  });


var config = {
  entry: [ './bin/sitefile.coffee' ],
  target: 'node',
  output: {
    filename: 'dist/sitefile.js',
    library: "sitefile_cli"
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ['babel'] },
			{ test: /\.coffee$/, loader: "coffee" },
			{ test: /\.json$/, loader: "json" },
			{ test: /\.pug$/, loader: "pug" }
    ]
  },
  externals: nodeModules,
  plugins: [
    new webpack.IgnorePlugin(/^(markdown|pug|stylus|pm2|pmx|knex)$/),
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
};

gulp.task('server-build', function(done) {
  webpack(config).run(function(err, stats) {
    if(err) {
      console.log('Error', err);
    }
    else {
      console.log(stats.toString());
    }
    gulp.src('dist/sitefile.js')
      .pipe(header('#!/usr/bin/env node\n'))
      .pipe(chmod(0755))
      .pipe(rename('sitefile'))
      .pipe(gulp.dest('./dist'))
    done();
  });
});

gulp.task('default', [ 'server-build' ]);
