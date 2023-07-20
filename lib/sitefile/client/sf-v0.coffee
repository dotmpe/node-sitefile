### lib/sitefile/client/sf-v0 - Main javascript for Sitefile client ###
define 'sf-v0', [

  'cs!base' # Boilerplate for all apps
  'cs!app' # An SfApp, new way to load/init client from resource meta

  'jquery'
  'bootstrap'
  'css!/vendor/bootstrap'
  'css!/vendor/bootstrap-theme'

], ( app, App, ClientModules ) ->

  console.log 'Node-Sitefile app starting...'
  
  { $, _ } = app.lib

  get_static_config = ->
    c = {}
    for mk in [ 'client-modules', 'client-meta' ]
      data = $("meta[name=sitefile-#{mk}]")
      if not data.length then continue
      c[mk] = data.attr('content').split(',')
    c

  sfapp_defaults = (cfg)->
    if 'client-meta' not in cfg
      cfg['client-meta'] = 'neighbour:yaml'
    cfg

  begin_apps = (cfg)->
    if 'client-modules' of cfg
      # Old main sitefile client
      require ['cs!sf-v0/component/client-modules'], ( ClientModules ) ->
        app._.push new ClientModules().start()

    app.meta = cfg['client-meta']

    app._.push new App(app)
    app.$.main = app._[-1]


  # The metadata can be provided in DOM elements *before* the script, so we
  # can get started directly.
  cfg = get_static_config()

  if 'client-modules' in cfg or 'client-meta' in cfg
    begin_apps cfg

  else
    # Or else wait for complete DOM and retry, defaulting to a new-style SfApp.
    $(document).ready ->
      begin_apps sfapp_defaults get_static_config()

#
