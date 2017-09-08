###

Component allows several independent mixins to merge into a single class, and 
to synchronise construction.

###
define 'sf-v0/component', [ 'lodash', 'cs!./module' ], ( _, Module ) ->


  field_names = [
      'create', 'ready', 'detach', 'destroy'
    ]

  class Component extends Module

    # Constructor
    create: []
    # DOM lifecycle
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

    @component_include: ( proto ) ->
      if proto.includes?
        # Add any module include field names to class var
        for fn in field_names
          if proto.includes[fn]?
            @::[fn] = @::[fn].concat proto.includes[fn]
