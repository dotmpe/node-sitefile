fs = require 'fs'
path = require 'path'
sitefile = require '../sitefile'
_ = require 'lodash'


# Given sitefile-context, export metadata for sass: handlers
module.exports = ( ctx ) ->

  try
    sass = require 'node-sass'
  catch
    return

  name: 'sass'
  label: 'SASS/SCSS publisher'
  usage: """
    sass:**/*.sass
  """

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        sasspath = if rctx.res.path then rctx.res.path else rctx.route.spec
        sitefile.log "SASS compile", sasspath
        sass.render {
          file: path.join ctx.cwd, sasspath
        }, ( err, rs ) ->
          if not _.isEmpty err
            res.type 'txt'
            res.status 500
            res.write String(err)
          else
            res.type 'css'
            res.write rs.css
          res.end()


