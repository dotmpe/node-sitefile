#_ = require 'lodash'
fs = require 'fs'
#path = require 'path'
#sys = require 'sys'
exec = require('child_process').exec
sitefile = require '../sitefile'


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
      ( req, res ) ->
        sitefile.log "Sh", rctx.res.path
        exec "sh #{rctx.res.path}", (error, stdout, stderr) ->
          if error != null
            res.status(500)
          res.write(stdout)
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



