###

Set up a RequireApp, loading modules specified by::

  meta[name='sitefile-client-modules']

###
define 'sf-v0/component/client-modules', [

  'cs!sf-v0/component/require-app'
  'cs!sf-v0/meta/client-modules'
  'event-signal'

], ( RequireApp, ClientModulesMeta, EventSignal ) ->


  class ClientModuleComponent extends RequireApp

    ###
    Client Modules are r.js modules loaded and initialized by the main
    application during page load, using names retrieved from a meta tag.

    XXX: Some components could already be loaded as they are compiled into the
    current require context, or because they are "hard-coded" into the HTML
    page. Neither form of pre-loading is used. The difficulty is that without
    prebuild contexts or pages the CSS loading will make it look choppy. Its
    up to the modules need to take care that their own initialization does not
    disturb the user experience.

    It does mean that the modules can completely manage their down dependencies.
    However to synchronize, ClientModuleComponent uses event-signal to emit
    changes on individual and the complete list of required components.
    ###

    start: ->

      @events.complete = new EventSignal()

      # Construct instance and start loading.
      @client_modules = new ClientModulesMeta().get()
      ready_on = @client_modules.length
      self = @

      @events.ready.addListener ( { name } ) ->
        self.loaded.push name
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
