###

Basic page abstraction for Sf client v0.

###
define 'sf-v0/mixin.page', [

  'jquery'

], ( $ ) ->


  Page:
    includes:
      create: [ 'page_init' ]
      ready: [ 'page_ready' ]

    container: null
    document: null

    page_init: ->
    page_ready: ->
      unless @container
        @container = $ 'body'
      $el = @get_page()
      if $el.length
        @merge_page $el
      else
        @container.append $el
    
    ###
    TODO: Merge in-memory temporary page with existing document.
    ###
    merge_page: ( $doc ) ->

    ###
    Return document container if it exists.
    ###
    get_page: ->
      $el = @container.children '.document'
      unless $el.length
        $el = @container.children '.container:first'
      return $el

    get_page_tpl: ->
      $ '<div class="document"><hr/></div>'
