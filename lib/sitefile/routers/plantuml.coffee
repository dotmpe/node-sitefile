fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
Promise = require 'bluebird'


plantuml = "java -jar plantuml.jar"


module.exports = ( ctx ) ->

  name: "plantuml"
  usage: """

  http://ogom.github.io/draw_uml/plantuml/
  https://chocolatey.org/packages/plantuml
  """

  auto_export:
    route:
      _plantuml: "plantuml:**/*.plantuml"
    
  default_handler: 'auto'

  defaults:
    default:
      route:
        options:
          xxx: 1

  generate:
    auto: ( rctx ) ->

      fname = rctx.res.path
      fbname = path.join rctx.res.dirname, rctx.res.basename

      generate = ( filepath, format ) ->
        new Promise ( resolve, reject ) ->
          exec "#{plantuml} #{fname} -t#{format} > #{fbname}.#{format}",
            (error, stdout, stderr) ->
              if error != null
                reject error
              else
                resolve [ stdout, stderr ]

      add_plantuml_convertor = ( format ) ->
        ctx.app.get rctx.res.ref+'.'+format, (req, res) ->
          ctx.log 'PlantUML', "Auto publishing", format: format
          res.type format
          generate(fname, format).then ->
            fs.readFile fbname+'.'+format, (err, data) ->
              if err
                res.type 'txt'
                res.status 500
                res.write String(err)
              else
                res.type format
                res.write data
              res.end()


      ctx.app.get rctx.res.ref, (req, res) ->
        fs.readFile fname, (err, data) ->
          res.type 'txt'
          if err
            res.status 500
            res.write String(err)
          else
            res.write data
          res.end()

      ctx.app.get rctx.res.ref+'.svg', (req, res) ->
        generate(fname, 'svg').then ( stdout, stderr ) ->
          #if stderr
          #  res.type 'txt'
          #  res.status 500
          #  res.write String(stderr)
          #else
          fs.readFile fbname+'.svg', (err, data) ->
            if err
              res.type 'txt'
              res.status 500
              res.write String(err)
            else
              res.type 'svg'
              res.write data
            res.end()

      for format in [ 'png', 'svg', 'html', 'txt', 'utxt', 'pdf' ]
        add_plantuml_convertor format

      null


