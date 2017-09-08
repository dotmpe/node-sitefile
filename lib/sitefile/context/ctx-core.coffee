# ## Sitefile Core Context-Prototype Mixin Module
#
# Initial incarnation of core util, merged directly into context prototype.
# of sf-context-proto:
# sitefile/context.coffee.

_ = require 'lodash'

libsf = require '../sitefile'
Router = require '../Router'


module.exports = ( ctx ) ->
  
  # ### Static module
  # configured using pre-constructor ctx object
  name: 'sf-core-context-proto'
  type: 'context-prototype'

  prototype:

    debug: ->
      if @config.verbose
        @log.apply null, arguments


    # See where to fetch more data, and populate context. Track and cache
    # for each resource in a map on context. Allow to override map by
    # another context-prototype, e.g. to persist or sync data with store.
    # This data should be flushable
    resolve_resource: ( req ) ->
      if req.route?
        d = @resource_group req


    # Return data for group
    resource_group: ( req ) ->
      unless req.route?
        throw new Error "Router context required"
      app.get 'route:'+req.route.path


    # TODO: auto-export routes given paths or globs, and extension map
    get_auto_export: ( router_name ) ->


    # Use router setings to determine opts per request (ie. to override from
    # query)
    req_opts: ( request, opts={} ) ->
      options = _.defaults opts, @route.options

      if 'query' of @route
        # Set default values for query keys
        _.defaults request.query, @route.query

      unless 'params' of @route and not @route['params']
        # By default merge req.params from route onto options
        _.defaults options, request.params

      # import-query: merge all or selected keys from query, resolve keys as
      # path-refs
      if @route['import-query']?
        mq = @route['import-query']
        if 'bool' is not typeof mq
          q = _.omitBy request.query, ( v, k ) -> k in mq
        else
          # NOTE: Merge everything from query
          q = request.query
        q = libsf.expand_obj_paths q
        _.merge options, q

      # Override rctx.res.path with query key, see query_path_export
      if @route['export-query-path']
        key = @route['export-query-path']
        if not options[key]
          options[key] = @route.spec.trim('#')
        options[key] = @query_path_export key, request, options[key]

      # Merge everything under the context path with options
      if @route['export-context']
        key = @route['export-context']
        o = libsf.expand_obj_paths "#{key}": @
        _.defaultsDeep options, o

      return options


    # If query key given use as rctx.res.path
    query_path_export: ( key, req, defpath ) ->
      # Assert rctx.res.path isset
      if defpath
        unless @res.path
          @res.path = defpath

      if not @res.path
        throw new Error \
          "A path is required either provided by query or option '#{key}'"

      if req.query?[key]
        @res.path = req.query[key]
      else
        req.query[key] = @res.path
      if not @res.path
        throw new Error \
          "A path is required either provided by query or option '#{key}'"

      # Resolve to existing path
      return Router.expand_path @res.path, @

