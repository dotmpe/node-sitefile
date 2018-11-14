_ = require 'lodash'
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

        # XXX: primitive, incomplete conneg, defaults
        d = 'application/json;filters=ansi-to-html'
        a = if req.headers.accept? is '*/*' then d \
          else _.defaultTo req.headers.accept, d
        unless a.match /filters=.*/
          a += d.substr 16

        # Conneg type/format accept
        out_fmt =
          if 'text/plain' in a then 'plain'
          else if a.match /filters=.*ansi-to-html/ then 'json-html'
          else 'json'
        sitefile.log "Sh", req.query.cmd, out_fmt

        # Execute local command
        exec "sh -c \"#{req.query.cmd}\"", (error, stdout, stderr) ->
          code = if error?.code then error.code else 0
          if error != null then res.status(400)
          out = if out_fmt is 'json'
            res.type 'json' ; JSON.stringify
              code: code
              stdout: stdout
              stderr: stderr
          else if out_fmt is 'json-html'
            res.type 'json' ; JSON.stringify
              code: code
              stdout: convert.toHtml stdout
              stderr: convert.toHtml stderr
          else if error then stderr else stdout
          res.write out
          res.end()

    ls: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "Sh ls", rctx.res.path
        exec "ls -la #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null then res.status(500)
          res.write stdout
          res.end()

    tree: ( rctx ) ->
      ( req, res ) ->
        sitefile.log "Sh tree", rctx.res.path
        exec "tree -fgups #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null then res.status(500)
          res.write stdout
          res.end()
