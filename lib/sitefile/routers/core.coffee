_ = require 'lodash'



jQuery_autocomplete_api = ( req, rctx ) ->

  gctx = rctx.context

  if req.query.recursive
    req.query.recursive = (req.query.recursive == "true")
  _.defaults req.query,
    prefix: ''
    recursive: true

  prefix = req.query.prefix
  term = req.query.term

  if ( term or prefix ) and rctx.verbose
    console.log "looking for paths with #{term} and/or in #{prefix}"

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
      res: data: rctx.context.routes

    autocomplete: ( rctx ) ->
      ( req, res ) ->
        data = jQuery_autocomplete_api req, rctx
        res.type 'json'
        res.write JSON.stringify data
        res.end()


