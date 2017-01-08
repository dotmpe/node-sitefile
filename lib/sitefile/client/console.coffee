define 'console', [

], ->

  console = window.console

  class SitefileConsole
    constructor: ->
      @logs = 0
      @_log = if console then console.log else null
      @debugs = 0
      @_debug = if console then console.debug else null
      @infos = 0
      @_info = if console then console.info else null
      @notices = 0
      @_note = if console then console.note else null
      @warnings = 0
      @_warn = if console then console.warn else null
      @errors = 0
      @_error = if console then console.error else null
      @assertions = 0
      @_assert = if console then console.assert else null
        
    log: ( m ) ->
      if @_log
        @_log m
      @logs += 1

    debug: ( m ) ->
      if @_debug then @_debug m
      else @_log m
      @debugs += 1

    info: ( m ) ->
      if @_info then @_info m
      else @_log m
      if sf_info_toast?
        sf_info_toast.setAttribute 'text', m
        sf_info_toast.open()
      @infos += 1

    note: ( m ) ->
      if @_note then @_note m
      else @_log m
      @notices += 1

    warn: ( m ) ->
      if @_warn then @_warn m
      else @_log m
      @warnings += 1

    error: ( m ) ->
      if @_error then @_error m
      else @_log m
      @errors += 1

    assert: ( c, m ) ->
      if @_assert then @_assert c, m
      else
        if c
          @warn m
          @assertions += 1

    monkey_patch: ( obj, atr )->
      obj[atr] = @[atr].bind @


  csl = new SitefileConsole()

  csl.monkey_patch console, 'log'
  csl.monkey_patch console, 'debug'
  csl.monkey_patch console, 'warn'
  csl.monkey_patch console, 'assert'

  csl.monkey_patch console, 'info'

  csl

