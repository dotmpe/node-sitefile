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
      compileDebug: false
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

  compilePug = ( optsIn, rctx ) ->
    opts = _.defaultsDeep {}, optsIn, pug_def_opts

    # Compile template from file
    pug.compileFile opts.tpl, opts.compile

  renderPug = ( optsIn, rctx ) ->
    tpl = compilePug optsIn, rctx

    # Merge with options and context
    opts.merge.context = rctx

    tpl opts.merge

  publishExpress = ( res, template, parts, rctx ) ->
    pugOpts = _.defaultsDeep rctx.route.options.pug, {
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

  compile: compilePug
  render: renderPug
  publish: publishExpress

  defaults:
    global:
      default:
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
        options: pug_def_opts

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->
        opts = rctx.req_opts req

        if rctx.res.rx?
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
        data = compilePug opts, rctx
        res.type opts.merge.format
        res.write data
        res.end()
