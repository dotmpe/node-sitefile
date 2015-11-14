#_ = require 'lodash'
fs = require 'fs'
#path = require 'path'
#sys = require 'sys'
exec = require('child_process').exec


# Given sitefile-context, export metadata for sh: handlers
module.exports = ( ctx={} ) ->

  name: 'sh'
  label: 'Shell publisher'
  usage: """
    sh:**/*.sh
  """

  # generators for Sitefile route handlers
  generate: ( spec, ctx={} ) ->

    fn = spec + '.sh'

    ( req, res ) ->

      exec "sh #{fn}", (error, stdout, stderr) ->
        if error != null
          res.status(500)
        res.write(stdout)
        res.end()

