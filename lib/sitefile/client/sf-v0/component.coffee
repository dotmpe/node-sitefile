###
  Component extends Module
  to allow subclasses to mixin prototypes that initialize at create or ready
  state. It adds an 'includes' moduleKeywords that may hold an object that lists
  calls for each of the states.

  To synchronise multiple includes running at a certain state, the include order
  matters. And it requires that prerequisites are fully loaded after include,
  ie. not dependent on another asynchronous call, like a require
  sub-configuration. But run-time sub-configuration may be a design choice; the
  initial client application will be loaded in its entirety. Sub-configurations
  may help keeping size down. And if the base app has been build, the aim is to
  still allow for extension without requiring to go back to the build system.

  However to synchronize dynamic includes, Component subclasses need to provide
  additional API and use call-backs and/or events to synchronise state of
  composite modules.

###
define 'sf-v0/component', [ 'lodash', 'cs!./module' ], ( _, Module ) ->


  field_names = [
      'create', 'ready', 'detach', 'destroy'
    ]
    
  class Component extends Module

    # On-contructor initializers
    create: []
    # On-attach to DOM initializers
    ready: []
    detach: []
    destroy: []

    constructor: ( @copts ) ->
      super()
      self = @
      for m in self.create
        self[m]()
      $(document).ready ->
        for m in self.ready
          self[m]()

    @include: ( proto ) ->
      if proto.includes
        if 'includes' not in @moduleKeywords
          @moduleKeywords.push 'includes'
        unless proto.on_module_include
          proto.on_module_include = ( proto ) ->
            Component.component_include.apply @, [ proto ]
      Module.include.apply @, [ proto ]

    @component_include: ( proto )->
      if proto.includes?
        # Add any module include field names to class var
        for fn in field_names
          if proto.includes[fn]?
            @::[fn] = @::[fn].concat proto.includes[fn]


