_ = require 'lodash'


jQuery_autocomplete_api = ( req, rctx ) ->

  if req.query.recursive
    req.query.recursive = (req.query.recursive == "true")
  _.defaults req.query,
    prefix: ''
    recursive: true

  prefix = req.query.prefix
  term = req.query.term
  if ( term or prefix )
    rctx.root().debug "looking for paths with #{term} and/or in #{prefix}"

  gctx = rctx.root()
  retdata = []
  matches = []
  for resource of gctx.routes.resources

    if prefix and not resource.startsWith prefix
      continue

    if prefix
      resource = resource.substr prefix.length

    if ( not req.query.recursive ) and resource.indexOf('/') != -1
      resource = resource.substring(1).split('/')[0]

    if term and resource.indexOf(term) is -1
      continue

    if resource in matches
      continue

    data = label: resource

    data.router = \
      gctx.routes.resources[resource].route.name+'.'+\
      gctx.routes.resources[resource].route.handler

    if -1 < resource.indexOf ':'
      data.restype = 'ParameterizedPath'
    else if resource.startsWith '_'
      data.restype = 'DynamicPath'
    else if gctx.routes.resources[resource].res?.path
      data.restype = 'StaticPath'
    else
      data.restype = 'OpaqueResource'

    data.category = if resource.startsWith '/note' then "Notes" \
      else if resource.startsWith '/personal' then "Personal" \
      else if resource.startsWith '/Dev' then "Development" \
      else "File"

    matches.push resource
    retdata.push data

  return retdata


module.exports = ( ctx ) ->

  # Router component as a plain object

  # Basic attributes
  name: 'core'
  label: 'Sitefile API service'
  usage: """
    core:
  """

  defaults:
    handler: 'routes'

  # Additional (user/Sitefile) configuration defaults for this module

  # Generate router API is free to either return an function to handle a
  # resource request context, or add Express handlers directly.
  generate:

    routes: ( rctx ) ->
      d = {}
      for k of rctx.context.routes.resources
        v = rctx.context.routes.resources[k]
        d[k] = v._data
      res: data: d

    route: ( rctx ) ->
      ( req, res ) ->
        rs = rctx.context.routes.resources
        ref = req.query.url
        if ref of rs
          res.type 'json'
          res.write JSON.stringify rs[ref]._data
        else
          # FIXME: no go with parameterized or regex Express routes
          res.status 500
          res.write "No endpoint found for #{ref}"
        res.end()

    autocomplete: ( rctx ) ->
      ( req, res ) ->
        data = jQuery_autocomplete_api req, rctx
        res.type 'json'
        res.write JSON.stringify data
        res.end()
