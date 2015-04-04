###
A coffeescript implementation of a context
with inheritance and override.

See also dotmpe/invidia for an JS context (without dynamic inheritance?)
###
_ = require 'lodash'

class Context

  constructor: ( init, ctx=null ) ->
    @_instance = ++ Context._i
    @context = ctx
    @_defaults = init
    @_data = {}
    @_subs = []
    if ctx and ctx._data
      @prepare_properties ctx._data
    @prepare_properties init
    @seed init

  path: ->
    if @context
      return @context.path + '/' + @_instance
    return '/' + @_instance

  toString: ->
    #console.log @constructor.name
    #console.log @path
    #( @constructor.name +':'+ @path )
    'Context:'+@path

  isEmpty: ->
    not _.isEmpty @_data

  _ctxGetter: ( k ) ->
    ->
      if k of @_data
        @_data[ k ]
      else if @context?
        @context[ k ]

  _ctxSetter: ( k ) ->
    ( newVal ) ->
      @_data[ k ] = newVal

  seed: ( obj ) ->
    for k, v of obj
      @_data[ k ] = v

  prepare_properties: ( obj ) ->
    for k, v of obj
      if k of @_data
        continue
      Object.defineProperty @, k,
        get: @_ctxGetter( k )
        set: @_ctxSetter( k )
        enumerable: true
        configurable: true
        #        writable: true

  getSub: ( init ) ->
    class SubContext extends Context
      constructor: ( init, sup ) ->
        Context.call @, init, sup
    sub = new SubContext init, @
    @_subs.push sub
    sub

Context._i = 0
Context.name = "context-mpe"
Context.version = "0.0.1"

module.exports = Context

