###
	Modify Docutils HTML output (and other text documents) with a few extra
	elements.
###
$.widget 'dotmpe.duPage',
  _create: ->
    unless this.element.hasClass 'document'
      this.element.addClass 'document'

    unless this.element.parent().children('.prologue').length
      prologue = $ '<div class="prologue"></div>'
      prologue.insertBefore this.element.parent().children '.document'

    unless this.element.parent().children('.header').length
      header = $ '<div class="container header"><hr/></div>'
      header.insertBefore this.element.parent().children '.document'

    unless this.element.parent().children('.epilogue').length
      epilogue = $ '<div class="epilogue"></div>'
      epilogue.insertAfter this.element.parent().children '.document'

    unless this.element.parent().children('.footer').length
      footer = $ '<div class="container footer"><hr/></div>'
      footer.insertAfter this.element.parent().children '.document'

