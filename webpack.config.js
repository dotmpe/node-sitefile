const webpack = require('webpack');
const fs = require('fs');

const config = {}

config.entry = [ './bin/sitefile.coffee' ]

// Node module dependencies should not be bundled
config.externals = fs.readdirSync("node_modules")
  .reduce(function(acc, mod) {
    if (mod === ".bin") {
      return acc
    }

    acc[mod] = "commonjs " + mod
    return acc
  }, {})

config.target = 'node'

//config.node = {
//  markdown: "empty",
//  "bookshelfapi": "empty"
//}

config.output = {
  filename: 'dist/sitefile.js'
}

config.module = {}

config.module.loaders = [
		{
			test: /\.js$/,
			exclude: /node_modules/,
			loaders: [
				"babel?{stage:0,jsxPragma:'this.createElement'}",
				"eslint",
			],
		},
		{
		  test: /\.coffee$/,
			exclude: /node_modules/,
		  loader: "coffee"
		},
		{ test: /\.json$/, loader: "json" }
	]

config.resolve = {
		extensions: [
		  "", ".coffee", ".js", ".json"
		]
	}

config.plugins = [
  new webpack.BannerPlugin('require("source-map-support").install();',
                                   { raw: true, entryOnly: false }),
  new webpack.IgnorePlugin(/markdown|pug|pug-runtime|stylus|pm2|pmx|knex|bookshelfapi/)
]

config.devtool = 'sourcemap'


module.exports = config

