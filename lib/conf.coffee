path = require 'path'
fs = require 'fs'
yaml = require 'js-yaml'

_ = require 'lodash'


defaults =
  get:
    paths: [
      '.'
      '~/'
      '/etc/'
    ]
    prefixes: [
      '.', ''
    ]
    suffixes: [
      '.json'
      '.yml'
      '.yaml'
    ]
    all: false

  load_file:
    name: 'Sitefile'
    ext: '.yml'

defaults.load =
  get: _.clone( defaults.get )
  load_file: _.clone( defaults.load_file )


get = ( name, opts={} ) ->

  _.defaults opts, defaults.get

  pwd = process.cwd()

  paths = []

  for p1 in opts.paths
    for p2 in opts.prefixes
      for s in opts.suffixes
        if p1 == '.'
          p1 = pwd
        p = path.join p1, p2 + name + s

        if fs.existsSync p
          paths.push path.relative( pwd, p )
          if not opts.all
            return paths[ 0 ]

  if opts.all
    return paths


load_file = ( fn, opts={} ) ->
  data

  _.merge opts, defaults.load_file
  if opts.ext == '.json'
    data = require fn
  else if opts.ext in [ '.yaml', '.yml' ]
    fp = fs.readFileSync fn, 'utf8'
    data = yaml.safeLoad fp
  else
    data = {}

  if opts.defaults
    _.defaults data, opts.defaults

  data


# Return merged data, loaded from one or more files
load = ( name, opts={} ) ->
  _.defaults opts, defaults.load
  paths = get name, opts.get
  if _.isEmpty paths
    throw new Error "Nothing to load for #{name}"
  #console.log "load #{name} found", paths, opts
  if not _.isArray paths
    paths = [ paths ]
  data = {}
  for p in paths
    obj = load_file p, opts.load_file
    _.merge data, obj
  data


module.exports =
  defaults: defaults
  get: get
  load_file: load_file
  load: load

