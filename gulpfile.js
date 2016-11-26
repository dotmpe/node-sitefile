var gulp = require('gulp');
var webpack = require('webpack');
var path = require('path');
var fs = require('fs');

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
    path: path.join(__dirname, 'build'),
    filename: 'sitefile'
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ['babel'] },
			{ test: /\.coffee$/, loader: "coffee" },
			{ test: /\.json$/, loader: "json" }
    ]
  },
  externals: nodeModules,
  plugins: [
    new webpack.IgnorePlugin(/markdown|pug|stylus|pm2|pmx|knex|bookshelfapi/),
    new webpack.IgnorePlugin(/\.(css|less)$/),
    new webpack.BannerPlugin('require("source-map-support").install();',
                             { raw: true, entryOnly: false })
  ],
	resolve: {
		extensions: [
			"", ".coffee", ".js", ".json"
		]
	},
  devtool: 'sourcemap'
}

gulp.task('server-build', function(done) {
  webpack(config).run(function(err, stats) {
    if(err) {
      console.log('Error', err);
    }
    else {
      console.log(stats.toString());
    }
    done();
  });
});

gulp.task('default', [ 'server-build' ]);
