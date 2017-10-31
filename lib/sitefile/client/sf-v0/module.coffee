###
  Module's main function is include, which allows to extend the prototype.
  Both functions have an optional callback on the argument object, with names
  as listed in moduleKeywords. These allow for additional customization after
  the actual extend/include has been executed.
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
