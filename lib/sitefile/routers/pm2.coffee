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

  name: 'pm2'

  generate:
    default: ( rctx ) ->

      console.log 'PM2', ctx.site.base, rctx.name, rctx.res, rctx.route
      if not rctx.res.path
        throw Error "JSON path expected"

      data = require path.join '../../..', rctx.res.path

      null

    ps: ( rctx ) ->

      console.log 'PM2 ps', ctx.site.base, rctx.name, rctx.res, rctx.route
      
      console.log ctx.site.base+rctx.name+'.json'

      # TODO: response with API json
      #ctx.app.get ctx.site.base+rctx.name+'.json', (req, res) ->
      #  res.type 'application/vnd.api+json'

      # List all PM2 procs in JSON
      ctx.app.get ctx.site.base+rctx.name+'.json', (req, res) ->
        pm2.list (err, ps_list) ->
          res.type 'json'
          if err
            res.status 500
          res.write JSON.stringify ps_list
          res.end()

      # Describe single PM2 proc in JSON
      ctx.app.get ctx.site.base+rctx.name+'/:pm_id.json', (req, res) ->
        pm2.describe req.params.pm_id, (err, ps_list) ->
          res.type 'json'
          if err
            res.status 500
          res.write JSON.stringify ps_list[0]
          res.end()

      ctx.app.post ctx.site.base+rctx.name+'/:pm_id/restart', (req, res) ->
        pm2.gracefulReload req.params.pm_id, ( err ) ->
          res.type 'txt'
          if err
            res.status 500
            res.write err
          res.end()

      ctx.app.post ctx.site.base+rctx.name+'/:pm_id/stop', (req, res) ->
        pm2.stop req.params.pm_id, ( err ) ->
          res.type 'txt'
          if err
            res.status 500
            res.write err
          res.end()


      # Serve PM2 proc HTML details
      ctx.app.get ctx.site.base+rctx.name+'/:pm_id.html', (req, res) ->

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


      # Serve HTML list view
      ctx.app.get ctx.site.base+rctx.name+'.html', (req, res) ->

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

      # Serve JS for list-view
      ctx.app.get ctx.site.base+rctx.name+'.js', (req, res) ->
        res.type 'js'
        res.write cc._compileFile listCoffeeFn
        res.end()

      null


