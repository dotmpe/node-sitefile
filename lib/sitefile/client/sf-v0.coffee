### lib/sitefile/client/sf-v0 - Simple jQ based hook for RJS to boot SitefilePage

Used on pages where sf-v0 is defined as rjs main app.

###
define 'sf-v0', [

  'jquery'
  #'cs!sf-v0/testmod'
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
      sf.page_data[mod_name] = i
      console.log 'Initialized client module', mod_name
                
  $(document).ready ( $ ) ->
    ###
    Simply bootstrap using module names from page head meta, or 'page'.
    Add another meta property to experiment with a more integrated metadata
    approach using a linked JSON.
    ###
    meta = $('meta[name=sitefile-client-modules]')
    client_modules = if meta.length then meta.attr('content').split( ',' ) \
      else [ 'page' ]

    # XXX: Value is an URL or DOM path ref, see PageComponent
    #meta = $('meta[name=sitefile-client-meta]')

    ###
    Load modules in two stages, first initialize those already loaded and
    note those not loaded yet. Then asynchronously load and initialize the rest.
    ###
    mod_names = []
    for mod_name in client_modules
      console.log 'Loading client module', mod_name
      mod = null
      try
        mod = require 'cs!./sf-v0/'+mod_name
      catch e
        if e.requireType is 'notloaded'
          mod_names.push 'cs!./sf-v0/'+mod_name
      if mod
        init_mod mod_name, mod
    if mod_names.length
      require mod_names, ->
        for mod in arguments
          if mod
            init_mod '', mod

    console.log "Sitefile sf-v0 rjs app initialized"

  null

