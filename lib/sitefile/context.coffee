_ = require 'lodash'

libsf = require './sitefile'
Router = require './Router'


# Extension prototypes for sitefile's Context
module.exports = ( ctx ) ->
  
  name: 'sf-context-proto'
  type: 'context-prototype'

  prototype:

    get_auto_export: ( router_name ) ->

    # Use router setings to determine opts per request (ie. to override from
    # query)
    req_opts: ( request ) ->

      options = _.merge {}, @route.options


      if 'import-query' of @route
        mq = @route['merge-query']
        if 'bool' is not typeof mq
          q = _.omitBy request.query, ( v, k ) -> k in mq
        else
          # NOTE: Merge everything from query
          q = request.query
        q = libsf.expand_obj_paths q
        _.defaultsDeep options, q

      if @route['export-query-path']
        key = @route['export-query-path']
        if not options[key]
          options[key] = @route.spec.substr 0, @route.spec.length-1 # XXX: hack hack
        options[key] = @query_path_export key, request, options[key]

      if @route['export-context']
        key = @route['export-context']
        _.defaultsDeep options, libsf.expand_obj_paths "#{key}": @

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

