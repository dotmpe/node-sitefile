path = require 'path'
fs = require 'fs'
exec = require('child_process').exec


# Given sitefile-context, export metadata for gv: handlers
module.exports = ( ctx={} ) ->

  name: 'gv'
  label: 'Graphviz Publisher'
  usage: """
    gv:**/*.dot.gv
    gv:**/*.neato.gv
    gv:**/*.twopi.gv
  """

  # generators for Sitefile route handlers
  generate: ( fn, ctx={} ) ->

    engine = 'dot'
    ext = path.extname(fn).substr(1)
    if (ext.match(/(dot|neato|twopi)/))
      engine = ext

    ( req, res ) ->

      exec "#{engine} -Tpng #{fn} -o #{fn}.png", (error, stdout, stderr) ->
        if error != null
          res.status 500
        try
          res.write fs.readFileSync fn+'.png'
        catch e
          console.error e
          console.log stdout
          res.write e.toString()
        res.end()

