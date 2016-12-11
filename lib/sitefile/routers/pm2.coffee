path = require 'path'
cc = require 'coffee-script'



module.exports = ( ctx ) ->

  try
    pm2 = require 'pm2'
  catch
    return

  httprouter = require('./http') ctx
  pugrouter = require('./pug') ctx
  
  detailPugFn = path.join( __dirname, 'pm2/view/detail.pug' )

  listPugFn = path.join( __dirname, 'pm2/view/list.pug' )
  listCoffeeFn = path.join( __dirname, 'pm2/view/list.coffee' )


  generators =
    default: ( rctx ) ->
      # FIXME: allow string descriptions;
      # auto-export routes based on route.default mapping
      console.log 'PM2', ctx.site.base, rctx.name, rctx.res, rctx.route

      route:
        '.json': get: generators.data
        '.js': get: generators.script
        '.html': get: generators.view
        '/:pm_id.html': get: generators['view/app']
        '/:pm_id.json': get: generators['data/app']
        '/:pm_id/reload': post: generators.reload
        '/:pm_id/restart': post: generators.restart
        '/:pm_id/stop': post: generators.stop
        '/': (req, res) ->
          res.redirect ctx.site.base+rctx.name+'.html'

    xxxxxxx: ( rctx ) ->
      # FIXME: return routes so Sitefile can set dir defaults
      #dir = path.dirname(ctx.site.base+rctx.name)
      if dir not of ctx.routes.directories
        ctx.routes.directories[ dir ] = []
      ctx.routes.directories[ dir ].push path.basename rctx.name

    data: ( rctx ) ->
      (req, res) ->
        pm2.list (err, ps_list) ->
          res.type 'json'
          if err
            res.status 500
          res.write JSON.stringify ps_list
          res.end()

    'data/app': ( rctx ) ->
      # Describe single PM2 proc in JSON
      (req, res) ->
        pm2.describe req.params.pm_id, (err, ps_list) ->
          res.type 'json'
          if err
            res.status 500
          res.write JSON.stringify ps_list[0]
          res.end()

    view: ( rctx ) ->
      # Serve HTML list view
      (req, res) ->

        httprouter.promise.json(
          hostname: 'localhost'
          port: ctx.app.get('port')
          path: ctx.site.base + rctx.name + '.json'
        ).then ( apps ) ->

          res.type 'html'
          res.write pugrouter.compile listPugFn, {
            compile: rctx.route.options.compile
            merge:
              pid: process.pid
              base: ctx.site.base+rctx.name
              script: ctx.site.base+rctx.name+'.js'
              options: rctx.options
              query: req.query
              context: rctx
              apps: apps
          }
          res.end()

    'view/app': ( rctx ) ->
      # Serve PM2 proc HTML details
      (req, res) ->

        console.log req.path.substring(0, req.path.length - 5) + '.json'
        httprouter.promise.json(
          hostname: 'localhost'
          port: ctx.app.get('port')
          path: req.path.substring(0, req.path.length - 5) + '.json'
        ).then ( app ) ->

          res.type 'html'
          res.write pugrouter.compile detailPugFn, {
            compile: rctx.route.options.compile
            merge:
              pid: process.pid
              base: ctx.site.base+rctx.name
              script: ctx.site.base+rctx.name+'.js'
              options: rctx.route.options
              query: req.query
              context: rctx
              app: app
          }
          res.end()

    script: ( rctx ) ->
      # Serve JS for list-view
      (req, res) ->
        res.type 'js'
        res.write cc._compileFile listCoffeeFn
        res.end()

    restart: ( rctx ) ->
      (req, res) ->
        pm2.gracefulReload req.params.pm_id, ( err ) ->
          res.type 'txt'
          if err
            res.status 500
            res.write err
          res.end()

    stop: ( rctx ) ->
      (req, res) ->
        pm2.stop req.params.pm_id, ( err ) ->
          res.type 'txt'
          if err
            res.status 500
            res.write err
          res.end()

    reload: ( rctx ) ->
      (req, res) ->
        pm2.gracefulReload req.params.pm_id, ( err ) ->
          res.type 'txt'
          if err
            res.status 500
            res.write err
          res.end()


  name: 'pm2'

  route:
    default:
      '/': 'redir:pm2.html'
      '.json': '.data'
      '.html': '.view'
      '.js': '.script'
      '/:pm_id.json': '.data/app'
      '/:pm_id.html': '.view/app'
      '/:pm_id/restart': '.restart'
      '/:pm_id/reload': '.reload'
      '/:pm_id/stop': '.stop'

  generate: generators

