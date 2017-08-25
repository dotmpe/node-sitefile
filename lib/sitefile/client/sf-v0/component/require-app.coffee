###

Using Require.js for dependency management is great, until your design wants to
create composite apps. Allowing for extensions requires a dynamic approach
to loading dependencies, and to still sychronize their lifecycle.

Events:
  require
    Triggered once loading module starts.
  load
    Triggered once static module data is available. Ie. parsed but not
    evaluated.
  init
    Triggered once either the module is instantiated or its init callback has
    returned.
  ready
    Triggered once the module signals its init callback is complete.

Note: the module names carried with the events are unnormalized.
###

define 'sf-v0/component/require-app', [

  'event-signal'

], ( EventSignal ) ->


  class RequireApp
    constructor: ->

      @events =
        require: new EventSignal()
        load: new EventSignal()
        init: new EventSignal()
        ready: new EventSignal()

      @loaded = []

      self = @

    ###
    require - create a new require.js context for the module. 
    ###
    require: ( name ) ->

      @events.require.emit name: name

      self = @
      require [ name ], ( mod ) ->
        self.events.load.emit name: name, module: mod

        if mod
          # Once something is loaded treat as something accepting a callback
          # to signal ready state, and a reference to the app object
          if mod.init_client_module?
            init_cb = mod.init_client_module
          else if "[object Function]" == toString.call(mod)
            init_cb = mod
          else
            init_cb = ( ready_cb ) ->
              new mod ready_cb, self

          it = init_cb (->
              self.events.ready.emit name: name, self: self, module: mod, args: arguments
            ), self
          self.events.init.emit name: name, self: self, instance: it, module: mod
