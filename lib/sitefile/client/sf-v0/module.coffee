###
  Module's main functions are `extend` and `include.
  Extend copies copies all key, value pais of another object to `this`.
  Include copies all to the prototype.

  Both ignore keys in `@moduleKeywords`, and both also have an optional
  call-back that is applied after the kv copy.
###
define 'sf-v0/module', [], ->


  class Module
    @moduleKeywords: ['on_module_extend', 'on_module_include']

    constructor: ->

    @extend: (obj) ->
      for key, value of obj when key not in @moduleKeywords
        @[key] = value

      obj.on_module_extend?.apply @, [ proto ]
      this

    @include: (proto) ->
      for key, value of proto when key not in @moduleKeywords
        # Assign properties to the prototype
        @::[key] = value

      proto.on_module_include?.apply @, [ proto ]
      this
