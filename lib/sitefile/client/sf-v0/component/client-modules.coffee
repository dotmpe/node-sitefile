###
The most simplest and first method to generate a the client for a
Require.JS config.

Here the metadata is embedded in HTML, and encoded as a list of
modules specified by a comma-separated list of RequireJS references::

  meta[name='sitefile-client-modules']

The default value, set in ClientModulesMeta is::

  [ 'cs!sf-v0/page' ]

Ofcourse this all depends on rjs config context that maps refs to paths and
URLs.
###
define 'sf-v0/component/client-modules', [

  'cs!sf-v0/component/require-app'
  'cs!sf-v0/meta/client-modules-meta'
  'event-signal'

], ( RequireApp, ClientModulesMeta, EventSignal ) ->


  class ClientModuleComponent extends RequireApp

    ###
    Client Modules are CommonJS modules loaded and initialized by the root
    require.js context.
    ###

    start: ->

      @events.complete = new EventSignal()

      # Construct instance and start loading.
      @client_modules = new ClientModulesMeta().get()
      ready_on = @client_modules.length

      self = @
      @events.ready.addListener ( { name } ) ->
        self.loaded.push name

        # Emit all ready event once all client modules are loaded
        if self.loaded.length == ready_on
          self.events.ready.emit name: 'all'
          self.events.complete.emit all: self.loaded

      ###
      Create a seperate context for each name.
      This assumes no module has been loaded yet.
      ###
      for name in @client_modules
        console.log 'Sitefile v0 r.js loading client-module', name
        @require name

      self
