_ = require 'lodash'



jQuery_autocomplete_api = ( req, rctx ) ->

  global_ctx = rctx.context

  if req.query.recursive
    req.query.recursive = (req.query.recursive == "true")
  _.defaults req.query,
    prefix: ''
    recursive: true

  data = []
  values = []
  for resource in global_ctx.routes.resources

    if req.query.prefix and not resource.startsWith req.query.prefix
      continue
    if req.query.prefix
      resource = resource.substr req.query.prefix.length
    if ( not req.query.recursive ) and resource.indexOf('/') != -1
      resource = resource.substring(1).split('/')[0]
    if resource.indexOf(req.query.term) is -1
      continue
    if resource in values
      continue

    if resource.startsWith '/note'
      cat = "Notes"
    else if resource.startsWith '/personal'
      cat = "Personal"
    else if resource.startsWith '/Dev'
      cat = "Development"
    else
      cat = "File"

    data.push
      label: resource
      category: cat
    values.push resource

  return data


module.exports = ( ctx ) ->

  # Return obj. w/ metadata & functions
  name: 'core'
  label: 'Sitefile API service'
  usage: """
    core:
  """

  defaults:
    route:
      handler: 'routes'
      options: {}

  prereqs: {}

  generate: ( rctx ) ->
    
    if !rctx.route.handler
      rctx.route.handler = 'routes'

    ( req, res, next ) ->

      res.type 'json'
      switch rctx.route.handler
        when "routes" then data = ctx.routes
        when "autocomplete"
          data = jQuery_autocomplete_api req, rctx
      res.write JSON.stringify data
      res.end()


