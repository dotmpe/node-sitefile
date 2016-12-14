"""
:Created: 2016-04-02

Ditaa_ is a Java program to render nice block and arrow diagrams
in PNG format from ASCII art.

Intro
-----
Formerly found ditaa as a rSt directive enhancement.
Exactly the thing for Sitefile to also support.

Dev
---
- Should use some kind of transparency in client format conneg.
- Should transparently build and redirect to PNG format.

TODO: I think other sf handlers routinely serve the other format while the
first format is indicated by the URL. Should review URL aliasing anyway.

FIXME: this will work, but a bit sloppy (once) and with only hardcoded paths
to the PNG results in the Sf.

.. _ditaa: http://ditaa.sourceforge.net/

"""

fs = require 'fs'
#path = require 'path'
#sys = require 'sys'
exec = require('child_process').exec
sitefile = require '../sitefile'


# Given sitefile-context, export metadata for ditaa: handlers
module.exports = ( ctx={} ) ->

  name: 'ditaa'
  label: 'ASCII graph to ..'
  usage: """

    ditaa:**/*.{ditaa->png}
		
    ditaa:?**/*.png
  """

  # generators for Sitefile route handlers
  generate:
    default: ( spec, ctx={} ) ->

      fn = spec + '.ditaa'

      ( req, res ) ->

        sitefile.log "Ditaa", fn
        exec "ditaa #{fn}", (error, stdout, stderr) ->
          if error != null
            res.status(500)
          res.write(stdout)
          res.end()


