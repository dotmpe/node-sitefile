fs = require 'fs'
path = require 'path'
_ = require 'lodash'

sitefile = require '../sitefile'
Router = require '../Router'


# Given sitefile-context, export metadata for scss: handlers
module.exports = ( ctx ) ->

  try
    scss = require 'scss'
  catch
    return

  name: 'scss'
  label: 'SCSS publisher'
  usage: """
    /static/path: scss:file-path.scss
    _dynamic_id: scss:**/*.scss
    r:/path(.*)regex: scss:path-prefix/
  """

  # generators for Sitefile route handlers
  generate:

    default: ( rctx ) ->

      ( req, res ) ->
        if rctx.res.rx?
          # Handle regex from routes with 'r:' prefix
          m = rctx.res.rx.exec req.originalUrl
          if rctx.route.spec
            scsspath = rctx.route.spec+m[1]+'.scss'
          else
            scsspath = m[1]+'.scss'
        else
          scsspath = if rctx.res.path then rctx.res.path else rctx.route.spec
        scsspath = Router.expand_path scsspath, ctx
        sitefile.log "SCSS compile", scsspath

        st = fs.statSync(scsspath)
        res.set 'Last-Modified', st.mtime.toUTCString()

        fs.readFile scsspath, ( err, fh ) ->
          scss.compile fh.toString(), ( err, css ) ->
            if not _.isEmpty err
              res.type 'txt'
              res.status 500
              res.write String(err)
            else
              res.type 'css'
              res.write css
            res.end()
#
