define 'sf-v0/mixin.du-page', [

  'jquery'

], ( $ ) ->


  DocutilsPage:

    init_document: ->
      @document = @container.children '.document'
      if not @document.length
        @document = $ '<div class="document"><hr/></div>'
        @container.append @document

    init_header: ->
      @header = @container.children '.header'
      if not @header.length
        @header = $ '<div class="header"><hr/></div>'
        @header.insertBefore @container.children '.document'

    init_footer: ->
      @footer = @container.children '.footer'
      if not @footer.length
        @footer = $ '<div class="footer"/>'
        @footer.insertAfter @container.children '.document'


