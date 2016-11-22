_ = require 'lodash'
fs = require 'fs'
path = require 'path'

librst2html = require './rst2html'

rst_reader = ( out, params={} ) ->

  name: 'rst-reader'
  label: 'Fancied-up single-page reader for rSt'
  generate: ( spec, ctx ) ->

  route:
    base: ctx.site.base
    'rst-reader':
      get: (req, res, next) ->

