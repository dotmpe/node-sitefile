
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
      self = @
      for m in self.create
        self[m]()
      $(document).ready ->
        for m in self.ready
          self[m]()

    @include: (obj) ->
      """
      After Module.include, merge create/ready/detach/destroy and then
      call obj.on_include if provided.
      """
      Module.include obj
      if obj.includes?
        for fn in field_names
          if obj.includes[fn]?
            @::[fn] = @::[fn].concat obj.includes[fn]
      if obj.on_include?
        obj.on_include @, obj


