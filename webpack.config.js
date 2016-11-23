
module.exports = {
  entry: './bin/sitefile.coffee',
  output: {
    filename: 'dist/sitefile.js'
  },
  node: {
    fs: "empty",
    child_process: "empty",
    net: "empty"
  },
	module: {
		loaders: [
			{ test: /\.coffee$/, loader: "coffee" },
			{ test: /\.json$/, loader: "json" }
		]
	},
	resolve: {
		extensions: [
		  "", ".coffee", ".js"
		]
	}
}

