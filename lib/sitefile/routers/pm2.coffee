fs = require 'fs'
path = require 'path'
cc = require 'coffeescript'
_ = require 'lodash'

deref = require '../deref'
Router = require '../Router'


pm2_app_defaults = ( obj ) ->
  _.defaultsDeep obj, {
    name: null
    pid: null
    pm_id: null
    pm2_env:
      status: null
      cwd: null
      pm_uptime: null
      pm_exec_path: null
      ENV: null
    versioning: {}
  }

class PM2Config
  constructor: ( @cwd ) ->
    @pm2_config = []
    @pm2_config_dir = null
    @pm2_config_file = null
  load: ( filename ) ->
    @pm2_config_file = filename
    if path.dirname(filename) != filename
      @pm2_config_dir = path.join @cwd, path.dirname filename
      if not fs.existsSync @pm2_config_dir
        throw new Error "Directory should exist: #{filename}"
    @pm2_config_file = path.join @cwd, filename
    if fs.existsSync @pm2_config_file
      @pm2_config = require(@pm2_config_file).apps
      for pm2_proc in @pm2_config
        pm2_app_defaults pm2_proc

class PM2Dump
  constructor: ( @cwd ) ->
    @pm2_dump = []
    @pm2_dump_dir = null
    @pm2_dump_file = null
  load: ( filename ) ->
    @pm2_dump_file = filename
    @pm2_dump_file = path.join @cwd, filename
    if not fs.existsSync @pm2_dump_file
      throw new Error "No such file #{filename}"
    @pm2_dump = require(@pm2_dump_file)

class PM2Manager
  constructor: ( @cwd ) ->
    @procs = []
  add: ( pm2_proc ) ->
    pm2_app_defaults pm2_proc
    @procs.push pm2_proc
  save: ->
  load: ( filename ) ->
    cfg = new PM2Config @cwd
    cfg.load filename
    @procs = cfg.pm2_config
  get_by_id: ( app_id) ->
    for app in @procs
      if app.pm_id == app_id
        return app
  get_by_name: ( app_name ) ->
    for app in @procs
      if app.name == app_name
        return app
  update_by_name: ( app ) ->
    for pm2_proc in @procs
      if app.name == pm2_proc.name
        _.merge pm2_proc, app
  name_exists: ( app_name ) ->
    for app in @procs
      if app.name == app_name
        return true
    return false


module.exports = ( ctx ) ->

  pug = require 'pug'
  pm2 = require 'pm2'

  httprouter = require('./http') ctx
  pugrouter = require('./pug') ctx
  
  detailPugFn = path.join( __dirname, 'pm2/view/detail.pug' )
  listPugFn = path.join( __dirname, 'pm2/view/list.pug' )
  listCoffeeFn = path.join( __dirname, 'pm2/view/list.coffee' )

  ### TODO: PM2Manager dump/config loader
  m = new PM2Manager ctx.cwd
  # If given, use spec for JSON config file
  if rctx.route.spec and rctx.route.spec != '#'
    m.load rctx.route.spec

  pm2.list (err, ps_list) ->
    for app in ps_list
      if m.name_exists app.name
        m.update_by_name app
      else
        m.add app
  ###

  generators =
    default: ( rctx ) ->
      # FIXME: allow string descriptions;
      # auto-export routes based on route.default mapping

      route =
        '.json': get: generators.list
        '-data.json': get: generators.data
        '.js': get: generators.script
        '.html': get: generators.view
        '/:pm_id.html': get: generators['view/app']
        '/:pm_id.json': get: generators['data/app']
        '/:pm_id/start': post: generators.start
        '/:pm_id/reload': post: generators.reload
        '/:pm_id/restart': post: generators.reload
        '/:pm_id/stop': post: generators.stop
        '': get: (rctx) ->
          (req, res) ->
            res.redirect ctx.site.base+rctx.name+'.html'
        '/': get: (rctx) ->
          (req, res) ->
            res.redirect ctx.site.base+rctx.name+'.html'

      # TODO: see r0.0.6 for module generate export scheme
      for name of route
        for method of route[name]
          ref = ctx.site.base+rctx.name+name
          if "object" is typeof route[name][method]
            rctx.res.data = route[name][method].res.data
            ctx.app[method] ref, Router.builtin.data ( rctx )
            continue
          unless "function" is typeof route[name][method]
            throw Error \
              "Expected callback #{name}:#{method}:#{route[name][method]}"
          r = route[name][method] rctx
          if "object" is typeof r
            throw Error "Expected callback #{name}:#{method}:#{r}"
          ctx.app[method] ref, r
      null

    # List all PM2 procs in JSON
    data: ( rctx ) ->
      (req, res) ->
        res.type 'json'
        res.write JSON.stringify m.procs
        res.end()

    list:
      res:
        data: ( rctx ) ->
          new Promise ( resolve, reject ) ->
            pm2.list ( err, ps_list ) ->
              if err
                reject err
              else
                resolve ps_list

    # Describe single PM2 proc in JSON
    'data/app': ( rctx ) ->
      (req, res) ->
        pm2.describe req.params.pm_id, (err, ps_list) ->
          res.type 'json'
          if err
            res.status 500
          res.write JSON.stringify ps_list[0]
          res.end()

    start: ( rctx ) ->
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

    # Serve JS for view(s?)
    script: ( rctx ) ->
      (req, res) ->
        res.type 'js'
        res.write cc._compileFile listCoffeeFn
        res.end()

    #  XXX: pm2_proc = m.get_by_id parseInt req.params.pm_id, 10

    # Serve HTML list view
    view: ( rctx ) ->
      (req, res) ->
        ctx.log 'PM2 View', path: ctx.site.base+ rctx.name + '.json'
        httprouter.promise.resource(
          reqType: 'application/json'
          opts:
            hostname: ctx.site.host
            port: ctx.app.get('port')
            path: ctx.site.base+ rctx.name + '.json'
        ).then ( data ) ->
          res.type 'html'
          res.write pugrouter.compile {
            tpl: listPugFn
            compile: rctx.route.options.compile
            merge:
              pid: process.pid
              pm2_base: ctx.site.base+rctx.name
              script: ctx.site.base+rctx.name+'.js'
              options: rctx.options
              query: req.query
              context: rctx
              apps: data[0]
              links: []
              stylesheets: \
                rctx.resolve('sitefile.defs.stylesheets.default') ? []
              scripts: rctx.resolve('sitefile.defs.scripts.default') ? []
              clients: []
          }
          res.end()

    # Serve PM2 proc HTML details
    'view/app': ( rctx ) ->
      (req, res) ->
        fn = req.path.substring(0, req.path.length - 5) + '.json'
        ctx.log 'PM2 View app', path: fn
        httprouter.promise.resource(
          opts:
            hostname: ctx.site.host
            port: ctx.app.get('port')
            path: fn
        ).then ( data ) ->
          res.type 'html'
          res.write pugrouter.compile {
            tpl: detailPugFn
            compile: rctx.route.options.compile
            merge:
              pid: process.pid
              pm2_base: ctx.site.base+rctx.name
              script: ctx.site.base+rctx.name+'.js'
              options: rctx.route.options
              query: req.query
              context: rctx
              app: data[0]
              links: []
              stylesheets: \
                rctx.resolve('sitefile.defs.stylesheets.default') ? []
              scripts: rctx.resolve('sitefile.defs.scripts.default') ? []
              clients: []
          }
          res.end()


  ### # TODO: see r0.0.6
  route:
    default:
      '/': 'redir:pm2.html'
      '.json': '.data'
      '.html': '.view'
      '.js': '.script'
      '/:pm_id.json': '.data/app'
      '/:pm_id.html': '.view/app'
      '/:pm_id/start': '.start'
      '/:pm_id/reload': '.reload'
      '/:pm_id/stop': '.stop'

  ###
  name: 'pm2'
  type: 'router'

  generate: generators

