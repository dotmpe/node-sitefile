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
  generate:
    default: ( rctx ) ->

      engine = 'dot'
      ext = path.extname(rctx.res.path).substr(1)
      if (ext.match(/(dot|neato|twopi)/))
        engine = ext

      ( req, res ) ->

        exec "#{engine} -Tpng #{rctx.res.path} -o #{rctx.res.path}.png",
          (error, stdout, stderr) ->
            if error != null
              res.status 500
            try
              res.write fs.readFileSync rctx.res.path+'.png'
            catch e
              console.error e
              console.log stdout
              res.write e.toString()
            res.end()

