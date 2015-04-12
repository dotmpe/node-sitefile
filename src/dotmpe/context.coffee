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
    return '#/' + @_instance

  toString: ->
    #console.log @constructor.name
    #console.log @path
    #( @constructor.name +':'+ @path )
    'Context:'+@path

  isEmpty: ->
    not _.isEmpty @_data

  # return a getter for property `k`
  _ctxGetter: ( k ) ->
    ->
      if k of @_data
        @_data[ k ]
      else if @context?
        @context[ k ]

  # return a setter for property `k`
  _ctxSetter: ( k ) ->
    ( newVal ) ->
      @_data[ k ] = newVal

  # seed property data from obj
  seed: ( obj ) ->
    for k, v of obj
      @_data[ k ] = v

  # Create local properties using keys in obj
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

  # get new subcontext:
  # create new SubContext instance that inherits from current instance
  getSub: ( init ) ->
    class SubContext extends Context
      constructor: ( init, sup ) ->
        Context.call @, init, sup
    sub = new SubContext init, @
    @_subs.push sub
    sub

  # get an object by json path reference,
  get: ( path ) ->
    p = path.split '.'
    c = @
    while p.length
      name = p.shift()
      if c[ name ]
        c = c[ name ]
      else
        throw new Error "Unable to resolve #{name} of #{path}"
    c

  # get an object by json path reference,
  # and resolve all contained references too
  resolve: ( path ) ->
    c = @get path
    self = @
    # recursively replace $ref: '..' with dereferenced value
    # XXX this starts top-down, but forgets context. may need to globalize
    merge = (result, value, key) ->
      if _.isArray value
        for item, index in value
          merge value, item, index
      else if _.isObject value
        if value.$ref # XXX resolve absolute JSON ref
          ref = value.$ref.substr(2).replace /\//g, '.'
          value = self.get ref
        else
          for key, property of value
            merge value, property, key
        result[ key ] = value
    _.transform c, merge

Context._i = 0
Context.name = "context-mpe"
Context.version = "0.0.1"


module.exports = Context

