#_ = require 'lodash'
fs = require 'fs'
#path = require 'path'
#sys = require 'sys'
exec = require('child_process').exec
Convert = require 'ansi-to-html'

sitefile = require '../sitefile'

convert = new Convert()


# Given sitefile-context, export metadata for sh: handlers
module.exports = ( ctx={} ) ->

  name: 'sh'
  label: 'Shell publisher'
  usage: """
    sh:**/*.sh
  """

  # generators for Sitefile route handlers
  generate:

    default: ( rctx ) ->
      # Generic sh path invocation
      ( req, res ) ->
        sitefile.log "Sh", rctx.res.path
        exec "sh #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null
            res.status(500)
          res.write(stdout)
          res.end()

    cmd: ( rctx ) ->
      # Generic sh invocation
      ( req, res ) ->
        sitefile.log "Sh", req.query.cmd
        # XXX: primitive, incomplete conneg
        if req.headers.accept? and 'text/plain' in req.headers.accept
          out_fmt = 'plain'
        else if req.headers.accept? and 'ansi-to-html=false' in req.headers.accept
          out_fmt = 'json'
        else
          out_fmt = 'json-html'

        exec "sh -c \"#{req.query.cmd}\"", (error, stdout, stderr) ->
          out = if out_fmt is 'json'
              res.type 'json' ; JSON.stringify
                stdout: stdout
                stderr: stderr
            else if out_fmt is 'json-html'
              res.type 'json' ; JSON.stringify
                stdout: convert.toHtml stdout
                stderr: convert.toHtml stderr
            else if error then stderr else stdout
          if error != null
            res.status(500)
          res.write(out)
          res.end()

    ls: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "Sh ls", rctx.res.path
        exec "ls -la #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null
            res.status(500)
          res.write(stdout)
          res.end()

    tree: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "Sh tree", rctx.res.path
        exec "tree -fgups #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null
            res.status(500)
          res.write(stdout)
          res.end()
