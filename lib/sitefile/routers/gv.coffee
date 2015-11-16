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
  generate: ( spec, ctx={} ) ->

    engine = path.extname(spec).substr(1)
    fn = spec + '.gv'

    ( req, res ) ->

      console.log "#{engine} -Tpng #{fn} -o #{spec}.png"

      exec "#{engine} -Tpng #{fn} -o #{spec}.png", (error, stdout, stderr) ->
        if error != null
          res.status 500
        try
          res.write fs.readFileSync spec+'.png'
        catch e
          console.error e
          console.log stdout
          res.write e.toString()
        res.end()

