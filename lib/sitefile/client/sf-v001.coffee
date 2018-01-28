define 'sf-v001', [

  'cs!sf-v0/component/require-app'
  'cs!sf-v0/meta/client-modules-meta'
  'event-signal'

  'cs!sf-v0/page'
  'cs!sf-v0/storage'
  'cs!sf-v0/microformats/live-code'
  'cs!sf-v0/microformats/href-registry'
  'cs!sf-v0/tilda'

  'jquery'
  'bootstrap'
  'css!/vendor/bootstrap'
  'css!/vendor/bootstrap-theme'

], ( RequireApp, ClientModulesMeta, EventSignal ) ->

  class App001 extends RequireApp
    start: ->
      @events.complete = new EventSignal()
      #@events.ready.addListener ( { name } ) ->
      @events.ready.emit name: 'all'
      @events.complete.emit all: [] #self.loaded

  (new App001()).start()
