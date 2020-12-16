_ = require 'lodash'
sitefile = require '../sitefile'
Router = require '../Router'


module.exports = ( ctx ) ->

  todotxt = require 'todotxt'
  #todotxt_parser = require 'todotxt-parser'

  cache = {}

  template = Router.expand_path 'sitefile-lib:routers/todo-html.pug', ctx

  sfpug = ctx._routers.get('pug')
  # XXX: debug console.log 'sfpug.defaults', sfpug.defaults

  todo_app_opts = sfpug.defaults.global.default.options

  name: 'todo'
  label: ''
  usage: """
    todo: todo.txt
  """

  defaults:
    handler: 'html'
    # Set default local/global options for route-generator handler(s)
    local:
      todo:
        pug:
          options: todo_app_opts

    global:
      txt: {}
      json: {}
      html:
        options: sfpug.defaults.global.default.options
        format: 'html'

  # Retrieve stat/file for TODO parser
  load: ( spec ) ->
    sffile = ctx._routers.get('file')
    if spec not in cache
      #sitefile.log 'TODO.txt', 'HTML (default) publisher now on %s' % ( spec )
      cache[spec] = new sffile.StaticFile spec
    else
      cache[spec].reload()
    cache[spec]

  # Reload file if needed and parse TODO
  parse: ( spec ) ->
    cfile = @load spec
    cfile.reload()
    # TODO: TodoFiles/TodoFile; parse only updated files
    todotxt.parse cfile.data

        #todos = todotxt_parser.relaxed file.data
        #file.toString()

  # Filter comments from TODO items since first parser includes those
  get: ( spec ) ->
    todos_ = @parse spec
    todos = []
    for it in todos_
      if not it or it.text.substr(0,1) is '#'
        continue
      todos.push it
    todos

  # Prepare template instance and merge options
  template: ( rctx ) ->
    #console.log 'template: route.options.pug', rctx.route.options.pug

    sfOpts = _.merge {}, rctx.route.options.pug, {
      tpl: template
      merge:
        todos: []
        html:
          main: ''
          document: ''
          footer: ''
        context: ctx
    }

    sfpug = ctx._routers.get 'pug'

    [ tplOpts, tpl ] = sfpug.init sfOpts, rctx

    [ tplOpts, tpl ]

  # Define default and/or other Express route-handler generators for this module
  generate:

    txt: ( rctx ) ->
      sfmod = ctx._routers.get('todo')
      file = sfmod.load(rctx.route.spec)
      ( req, res ) ->
        file.reload()
        res.type 'txt'
        res.write file.toString()
        res.end()

    json: ( rctx ) ->
      sfmod = ctx._routers.get('todo')
      file = sfmod.load(rctx.route.spec)
      ( req, res ) ->
        todos = sfmod.get(rctx.route.spec)
        res.type 'json'
        res.write JSON.stringify(todos)
        res.end()

    html: ( rctx ) ->
      sfmod = ctx._routers.get('todo')

      [ tplOpts, tpl ] = sfmod.template rctx

      # Pre-cache raw file data
      file = sfmod.load(rctx.route.spec)

      ( req, res ) ->
        res.type 'html'

        # Reload if needed, parse items
        tplOpts.merge.todos = sfmod.get(rctx.route.spec)

        #console.log 'todo.html: pug.merge', tplOpts.merge.clients
        res.write tpl tplOpts.merge
        res.end()

#
