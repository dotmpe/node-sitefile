_ = require 'lodash'



jQuery_autocomplete_api = ( req, rctx ) ->

  global_ctx = rctx.context

  if req.query.recursive
    req.query.recursive = (req.query.recursive == "true")
  _.defaults req.query,
    prefix: ''
    recursive: true

  prefix = req.query.prefix
  term = req.query.term
  console.log "looking for paths with #{term} and/or in #{prefix}"

  data = []
  values = []
  for resource in global_ctx.routes.resources

    if prefix and not resource.startsWith prefix
      continue
    if prefix
      resource = resource.substr prefix.length
    if ( not req.query.recursive ) and resource.indexOf('/') != -1
      resource = resource.substring(1).split('/')[0]
    if term and resource.indexOf(term) is -1
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

  # Router component as a plain object

  # Basic attributes
  name: 'core'
  label: 'Sitefile API service'
  usage: """
    core:
  """

  default_handler: 'routes'

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
        res.write JSON.stringify datajkkkkkkkkkkkkkkk
        res.end()


