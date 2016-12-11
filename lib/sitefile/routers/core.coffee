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
      res: data: [1,2,3]#rctx.context.routes
    autocomplete:
      res: data: ( rctx ) ->
        jQuery_autocomplete_api req, rctx



