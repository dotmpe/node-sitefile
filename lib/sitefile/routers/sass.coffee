fs = require 'fs'
path = require 'path'
_ = require 'lodash'

sitefile = require '../sitefile'
Router = require '../Router'


# Given sitefile-context, export metadata for sass: handlers
module.exports = ( ctx ) ->

  try
    sass = require 'node-sass'
  catch
    return

  name: 'sass'
  label: 'SASS/SCSS publisher'
  usage: """
    /static/path: sass:file-path.sass
    _dynamic: sass:**/*.sass
    r:/path(.*)regex: sass:path-prefix/
  """

  # generators for Sitefile route handlers
  generate:

    default: ( rctx ) ->

      ( req, res ) ->
        if rctx.res.rx?
          m = rctx.res.rx.exec req.originalUrl
          if rctx.route.spec
            sasspath = rctx.route.spec+m[1]+'.sass'
          else
            sasspath = m[1]+'.sass'
        else
          sasspath = if rctx.res.path then rctx.res.path else rctx.route.spec
        sasspath = Router.expand_path sasspath, ctx
        sitefile.log "SASS compile", sasspath

        st = fs.statSync(sasspath)
        res.set 'Last-Modified', st.mtime.toUTCString()

        sass.render {
          file: sasspath
        }, ( err, rs ) ->
          if not _.isEmpty err
            res.type 'txt'
            res.status 500
            res.write String(err)
          else
            res.type 'css'
            res.write rs.css
          res.end()
