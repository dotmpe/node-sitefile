path = require 'path'
glob = require 'glob'
_ = require 'lodash'


builtin =

  redir: ( route, url, handler_spec, ctx )->
    if not url
      url = ctx.base + route
    p = ctx.base + handler_spec
    ctx.redir url, p
    ctx.log '     *', url: url, '->', url: p

  static: ( route, url, handler_spec, ctx ) ->
    # FIXME: if not url
    url = ctx.base + route
    p = path.join ctx.cwd, handler_spec
    ctx.app.use url, ctx.static_proto p
    ctx.log 'Static', url: url, '=', path: handler_spec


Base =
  name: 'Express'
  label: 'Express-Sitefile resource publisher'
  usage: """
  
    Static path
      /path: <router[.handler-generator]>:<handler-spec>

    Leading underscore
      _route_id: <router[.handler-generator]>:<handler-spec>
  
  TODO: maybe, later:
  
    Dollar path.
      /data/$record: <router[.handler-generator]>:<handler-spec>

    Prefix path
      /prefix$: <router[.handler-generator]>:<handler-spec>

  
  Also: handler-spec vs. glob-spec. Routers should parse own args.

  Router.Base provide some standard resolvers:

  - path/to/file-name.ext1.ext2
  - path/to/dir

  """

  #parse_spec: ( route_spec, handler_spec, ctx )->

  # process parametrized rule
  #else if '$' in route
  #  url = ctx.base + route.replace('$', ':')
  #  log route, url: url
  #  app.all url, handler.generator '.'+url, ctx


module.exports =
  builtin: builtin
  Base: Base
  define: ( mixin )->
    _.assign {}, Base, mixin

