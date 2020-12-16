###
pug[.default=vanilla]
pug.plain:<pathspec>?pug.compile..=..&pug.merge..=..
pug.vanilla:<pathspec>?style=sitefile-document
pug.rjs:<pathspec>?main=default-requirejs
###
_ = require 'lodash'
path = require 'path'
escape = require 'escape-html'

sitefile = require '../sitefile'
Router = require '../Router'


pug_ext = ( pug ) ->
  pug.filters.code = ( block ) ->
    escape block

  pug.filters['lorem-ipsum-filler-body'] = ( block ) ->
    """
   <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium
   doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore
   veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim
   ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
   consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque
   porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur,
   adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et
   dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis
   nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex
   ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea
   voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem
   eum fugiat quo voluptas nulla pariatur?</p>

   <p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis
   praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias
   excepturi sint occaecati cupiditate non provident, similique sunt in culpa
   qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum
   quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum
   soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime
   placeat facere possimus, omnis voluptas assumenda est, omnis dolor
   repellendus.
   Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus
   saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.
   Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis
   voluptatibus maiores alias consequatur aut perferendis doloribus asperiores
   repellat.</p>
  """


# Given sitefile-context, export metadata for pug: handlers
module.exports = ( ctx ) ->

  try
    pug = require 'pug'
  catch
    return

  pug_ext pug

  pug_def_opts =
    tpl: null
    compile:
      pretty: false
      debug: false
      #compileDebug: false # makes things worse 'TypeError: str.split is not a function'
      basedir: '/'
      globals: []
      filters: {}
    merge:
      format: 'html'
      links: []
      meta: []
      stylesheets: []
      scripts: []
      clients: []
      context: ctx
    # insert require or other function(s) as local while merging pug template
    'insert-local': false

  newPug = ( optsIn, rctx ) ->
    # Should already be there, but just in case some got lost somewhere
    opts = _.defaultsDeep optsIn, pug_def_opts

    # Compile template from file
    [ opts, pug.compileFile opts.tpl, opts.compile ]

  renderPug = ( optsIn, rctx ) ->
    [ opts, tpl ] = newPug optsIn, rctx
    opts.merge.rcontext = rctx
    tpl opts.merge

  publishExpress = ( res, template, parts, rctx ) ->
    pugOpts = _.defaultsDeep {}, rctx.route.options.pug, {
      merge:
        ref: rctx.res.ref
        html: parts
        context: ctx
    }

    # Handle Express HTTP response
    res.type pugOpts.merge.format
    res.write template pugOpts.merge
    res.end()


  name: 'pug'
  label: 'Pug templates'
  usage: """
    pug:**/*.pug
  """

  compile: newPug # TODO rename every compile->merge
  init: newPug # TODO rename every compile->merge
  render: renderPug
  publish: publishExpress

  defaults:
    global:
      default:
        # defaults for Route.options
        options: pug_def_opts
        # sitefile.context.query_path_export settings: override res.path with
        # query key
        'export-query-path': 'tpl'
        # Use sitefile.context.req_opts to parse router options from context
        # export-context: deep-merge everything at global context path to
        # options
        'export-context': 'merge.context'
        # import-query: merge selected keys from query, resolve keys as
        # path-refs
        'import-query': [ 'merge.format', 'merge.scripts', 'merge.stylesheets' ]
      html: {}
      text: {}

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      #console.log "rctx.route.spec, rctx.route", rctx.route.spec, rctx.route
      if 'route' of rctx.route.options
        _.merge rctx.route, rctx.route.options.route

      ( req, res ) ->
        opts = rctx.req_opts req
        # XXX: if pug debug:
        #console.log 'pug.default: opts', opts

        if rctx.res.rx?
          # Handle regex from routes with 'r:' prefix
          m = rctx.res.rx.exec req.originalUrl
          if rctx.route.spec
            rctx.res.path = rctx.route.spec+m[1]+'.pug'
          else
            rctx.res.path = m[1]+'.pug'
        else
          rctx.res.path = if rctx.res.path then rctx.res.path
          else rctx.route.spec
        opts.tpl = Router.expand_path rctx.res.path, ctx

        ctx.process_meta opts.merge.meta
        sitefile.log \
          "Pug compile", path: opts.tpl, '(Route:', path: rctx.res.ref, \
          ' Spec:', path: rctx.res.path, ')'

        opts.merge['rcontext'] = rctx
        #[pugOpts, tpl] = newPug opts, rctx
        tpl = pug.compileFile opts.tpl, opts.compile

        # Templates can log to console.
        # But can't read files or import data on its own.
        if opts['insert-local']
          # XXX: why wont this work; opts.compile.globals = opts['insert-local']
          if 'bool' is typeof opts['insert-local']
            opts.merge['require'] = require
          else
            # There are no aliases, or function imports. Only modules. Use
            # 'locals' to access module names that do not map to a valid
            # variable. E.g. li = locals['lorem-ipsum'].
            for func_name in opts['insert-local']
              if 'undefined' is typeof module[func_name]
                func = require(func_name)
              else
                func = module[func_name]
              opts.merge[func_name] = func

        # if pug debug:
        #console.log 'pug.default: opts.merge', opts.merge

        # Finish response
        res.type opts.merge.format
        try
          doc = tpl opts.merge
        catch error
          console.error(error.toString())
          res.status 500
          res.type 'txt'
          res.write error.toString()
          res.end()
          return
        res.write doc
        res.end()
