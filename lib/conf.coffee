path = require 'path'
fs = require 'fs'
yaml = require 'js-yaml'

_ = require 'lodash'
liberror = require './error'


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

  expand_path:
    cwd: process.cwd()
    paths:
      prefixes:
        lib: __dirname+'/'


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

        if p.startsWith '~'
          p = process.env.HOME + p.substr(1)

        if fs.existsSync p
          paths.push path.relative( pwd, p )
          if not opts.all
            return paths[ 0 ]

  if opts.all
    return paths


load_file_opts = ( fn, opts={} ) ->
  if '#' in fn
    [ fn, lspec ] = fn.split '#', 1
  opts.ext = path.extname fn
  opts.name = path.basename fn, opts.ext
  _.merge opts, defaults.load_file

load_file = ( fn, opts, ctx ) ->
  data
  opts = load_file_opts fn, opts
  fn = expand_path fn, ctx
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

read_xref = ( ctx, spec ) ->
  ###
    Load data (JSON/YAML) file using load_file.
    The spec can be a filename or local JSON reference with fragment pointer.
    See feature-metadata docs.
  ###
  if not spec or '#' not in spec
    throw new Error "Empty or invalid spec found: '#{spec}'"
  [ datafn, spec ] = spec.split '#'
  o = load_file datafn, ctx
  # NOTE: very, very simple path-like attribute access
  p = spec.split '/'
  if not p[0]
    p.shift()
  c = o
  while p.length
    e = p.shift()
    c = c[e]
  return c

expand_path = ( src, opts ) ->
  opts = _.defaultsDeep opts, defaults.expand_path
  for prefix of opts.paths.prefixes
    if src.startsWith "#{prefix}:"
      return src.replace "#{prefix}:", opts.paths.prefixes[prefix]
  ### XXX:
  if not src.startsWith path.sep
    src = path.join opts.cwd, src
  ###
  src

# Return merged data, loaded from one or more files
load = ( name, opts={} ) ->
  _.defaults opts, defaults.load
  paths = get name, opts.get
  if _.isEmpty paths
    throw new liberror.types.NoFilesException "No PATH for #{name}"
  if not _.isArray paths
    paths = [ paths ]
  data = {}
  for p in paths
    obj = load_file p, opts.load_file, opts
    _.merge data, obj
  data


module.exports =
  defaults: defaults
  get: get
  load_file: load_file
  load: load
  expand_path: expand_path
  read_xref: read_xref

