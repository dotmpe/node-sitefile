###
pug[.default=vanilla]
pug.plain:<pathspec>?pug.compile..=..&pug.merge..=..
pug.vanilla:<pathspec>?style=sitefile-document
pug.rjs:<pathspec>?main=default-requirejs
###
_ = require 'lodash'
path = require 'path'
sitefile = require '../sitefile'

escape = require 'escape-html'

pug_ext = ( pug ) ->
  pug.filters.code = ( block ) ->
    escape block
  
  pug.filters['lorem-ipsum-filler-body'] = ( block ) ->
    # not really LI but need a filler
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

  compilePug = ( path, options ) ->

    # Compile template from file
    tpl = pug.compileFile path, options.compile

    # Merge with options and context
    tpl options.merge


  name: 'pug'
  label: 'Pug templates'
  usage: """
    pug:**/*.pug
  """

  compile: compilePug

  defaults:
    default:
      route:
        options:
          scripts: []
          stylesheets: []
          pug:
            format: 'html'
            compile:
              pretty: false
              debug: false
              compileDebug: false
              globals: []

  # generators for Sitefile route handlers
  generate:
    default: ( rctx ) ->
      ( req, res ) ->

        #XXX:console.log 'Pug compile', path: rctx.res.path, \
        #    "with", options: rctx.route.options

        pugOpts = {
          compile: rctx.route.options.pug.compile
          merge:
            options: rctx.route.options
            query: req.query
            context: rctx
        }

        if not pugOpts.compile.filters
          pugOpts.compile.filters = {}

        res.type rctx.route.options.pug.format
        res.write compilePug rctx.res.path, pugOpts
        res.end()


