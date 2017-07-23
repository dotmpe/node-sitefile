
$.widget 'dotmpe.styleSelector',
  options:
    create: 'append'
  _create: ->
    if @options.create
      @_createHTML
      el = $(div).find('.panel-body')
    else
      el = this.element
    this.numid = 0
    unless this.element.hasClass 'styleSelector'
      this.element.addClass 'styleSelector'
    c = if this.element.tagName in [ 'ol', 'ul' ] then this.element
    else document.createElement('ul') and this.element.append c
    for cn in [ 'selectable' ]
      unless $(c).hasClass cn
        $(c).addClass cn
    for script in $('link[rel=stylesheet]')
      li = $ '<li></li>'
      li.addClass 'ui-widget-content'
      li.text script.name or script.href
      unless script.id
        script.id = this.newId()
      li.id = 'styleSelector'+script.id
      li.attr 'data-id', script.id
      script = $(script)
      unless script.attr 'disabled'
        li.addClass 'ui-selected'
      c.append li
    $(c).selectable()

    $(c).on "selectableselected", ( event, ui ) ->
      $("link#"+ $(ui.unselected).attr('data-id') ).removeAttr 'disabled'
      $("link#"+ $(ui.selected).attr('data-id') ).attr 'rel', 'stylesheet'

    $(c).on "selectableunselected", ( event, ui ) ->
      $("link#"+ $(ui.selected).attr('data-id') ).attr 'disabled', 'disabled'
      $("link#"+ $(ui.unselected).attr('data-id') ).attr 'rel', ''

  newId: ->
    this.numid += 1
    "_auto#{this.numid}"

  _createHTML: ->
    unless $('#style-selector').length
      div = $ '<div class="container" id="style-selector">
          <div class="panel panel-default">
            <div class="panel-heading clearfix">
              <h3 class="panel-title pull-left">Style selector</h3>
              <button type="button" class="pull-right close"
                  data-target="#style-selector"
                  data-dismiss="alert">
                <span aria-hidden="true">&times;</span>
                <span class="sr-only">Close</span>
              </button>
            </div>
            <div class="panel-body">
            </div>
            <div class="panel-footer">
            </div>
          </div>
        </div>'
      if @options.create == 'append'
        @element.append div
      else if @options.create == 'prepend'
        @element.prepend div
      else if @options.create == 'before'
        @element.before div
      else
        throw new Error \
          "Invalid spec for styleSelector option 'create': '#{@options.create}'"



