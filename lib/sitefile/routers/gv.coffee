path = require 'path'
fs = require 'fs'
exec = require('child_process').exec
mimes = require 'mime-types'

# Given sitefile-context, export metadata for gv: handlers
module.exports = ( ctx={} ) ->

  mimes = {
    ps: 'application/postscript'
    svg: 'image/svg+xml'
    fig: 'image/vnd.xfig'
    imap: ' application/imagemap'
    cmapx: 'application/client-imagemap'
    gif: 'image/gif'
    png: 'image/png'
  }

  name: 'gv'
  label: 'Graphviz Publisher'
  usage: """
    gv:**/*.dot.gv
    gv:**/*.neato.gv
    gv:**/*.twopi.gv
  """

  promise:
    resource: ( { src, dst, format, engine, rctx } ) ->

      new Promise (resolve, reject) ->

        ext = path.extname(src).substr(1)

        if not engine
          engine = if (ext.match(/(dot|neato|twopi)/)) \
            then ext \
            else 'dot'

        if not dst
          dst = path.join path.dirname(src), \
            path.basename(src, '.gv')+'.'+format

        console.log "#{engine} -T#{format} #{src} -o #{dst}"
        exec "#{engine} -T#{format} #{src} -o #{dst}",
          (error, stdout, stderr) ->
            if error != null
              console.error error, stderr
              reject([ error, stdout, stderr ])
            data = null
            console.log 'readFileSync', path.join ctx.cwd, dst
            try
              data = fs.readFileSync path.join ctx.cwd, dst
            catch e
              console.error e
              reject([ e, stderr ])
            resolve( data )


  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->

      # PNG handler
      ctx.app.get rctx.res.ref+'.png', ( req, res ) ->
        ctx._routers.get('gv').promise.resource(
          src: rctx.res.path
          format: 'png'
        )
        .then (data) ->
          console.log 'done', data.length, mimes['png']
          res.type mimes['png']
          res.write(data)
          res.end()
        .catch (error) ->
          console.error 'gv-to-png', error
          res.status 500
          res.write String(error)
          res.end()

      # Default redirect to PNG
      ctx.redir rctx.res.ref, rctx.res.ref+'.png'

      null
      
