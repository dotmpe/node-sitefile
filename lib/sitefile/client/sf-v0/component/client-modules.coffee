###

Set up a RequireApp, loading modules specified by::

  meta[name='sitefile-client-modules']

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
