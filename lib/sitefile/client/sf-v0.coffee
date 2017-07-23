### lib/sitefile/client/sf-v0 - Simple jQ based hook for RJS to boot SitefilePage

Used on pages where sf-v0 is defined as rjs main app.

###
define 'sf-v0', [

  'jquery'
  'cs!sf-v0/page'

  'bootstrap'
  'css!/vendor/bootstrap'
  'css!/vendor/bootstrap-theme'

], ( $, SitefilePage ) ->

  console.log 'sf-v0 rjs loading'

  window.sf = fs = {}
  sf.page_data =
    modules: {}

  init_mod = ( mod_name, mod ) ->
    i = new mod()
    if mod_name
      console.log 'Loaded client module', mod_name
      sf.page_data[mod_name] = i
      console.log 'Initialized client module', mod_name
                
  $(document).ready ( $ ) ->
    meta = $('meta[name=sitefile-client-modules]')
    if meta.length
      client_modules = meta.attr('content').split ','
    else
      client_modules = [ 'page' ]

    mod_names = []
    for mod_name in client_modules
      console.log 'Loading client module', mod_name
      mod = null
      try
        mod = require 'cs!./sf-v0/'+mod_name
      catch e
        #console.warn "Client module '#{mod_name}' is not available", e,
        #  e.requireType, e.requireModules
        if e.requireType is 'notloaded'
          mod_names.push 'cs!./sf-v0/'+mod_name
      if mod
        init_mod mod_name, mod
    if mod_names.length
      require mod_names, ->
        for mod in arguments
          if mod
            init_mod '', mod

    console.log "Sitefile page initialized"

  null

