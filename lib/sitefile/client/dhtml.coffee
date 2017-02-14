

$.widget 'custom.duPage',
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


$.widget 'custom.rightNavMenu',
  _create: ->
    navId = this.options.data.id
    nav = $ 'nav#'+navId
    unless nav.length
      nav = $ """
        <nav class="navbar navbar-default navbar-fixed-top" id="#{navId}">
          <div class="container-fluid">
          </div>
        </nav>"""
      this.element.prepend nav
      for item in this.options.data.items
        this._addNavItem nav.find('.container-fluid'), item

  _addNavItem: ( dom, item ) ->
    menu = $ """
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav navbar-right">
          </ul>
        </div>
      """
    sub = menu.find 'ul.nav'
    this._addNavMenuItem sub, item
    dom.append menu

  _addNavMenuItem: ( dom, item ) ->
    icon = if item.icon? then item.icon else 'asterisk'
    label = if item.label? then item.label else ''
    li = $ """
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"
              role="button" aria-haspopup="true" aria-expanded="false">
            #{label} <span class="glyphicon glyphicon-#{icon}"
                aria-hidden="true"></span>
          </a>
        </li>
      """
    if item.items?
      ul = this._addMenu li, item
      ul.addClass 'multi-level'
    dom.append li

  _addMenu: ( dom, item ) ->
    dropdown = $ """<ul></ul>"""
    dropdown.addClass 'dropdown-menu'
    this._addMenuItems dropdown, item.items
    dom.append dropdown
    dropdown

  _addMenuItems: ( dom, items ) ->
    for item in items
      iType = if item.type? then item.type \
        else if item.href? then 'link' \
        else if item.label? then 'leaf' \
        else 'separator'
      href = if item.href? then item.href else '#'
      if iType == 'separator'
        li = $ '<li role="separator" class="divider"></li>'
      else if iType == 'header'
        li = $ """<li class="dropdown-header">#{item.label}</li>"""
      else
        if item.items?
          li = $ """<li class="item-#{iType} dropdown-submenu pull-left">
                        <a class="dropdown-toggle" data-toggle="dropdown"
                                    href="#{href}">#{item.label}</a></li>"""
          this._addMenu li, item
        else
          li = $ """<li class="item-#{iType}">
                        <a href="#{href}">#{item.label}</a></li>"""
      if item.click?
        li.find('a').click item.click
      dom.append li


$.widget 'custom.leftNavMenu',
  _create: ->
    navId = this.options.data.id
    nav = $ 'nav#'+navId
    unless nav.length
      nav = $ """
        <nav class="navbar navbar-default navbar-fixed-top" id="#{navId}">
          <div class="container-fluid">
          </div>
        </nav>"""
      this.element.prepend nav
      for item in this.options.data.items
        this._addNavItem nav.find('.container-fluid'), item

  _addNavItem: ( dom, item ) ->
    menu = $ """
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
          </ul>
        </div>
      """
    sub = menu.find 'ul.nav'
    this._addNavMenuItem sub, item
    dom.append menu

  _addNavMenuItem: ( dom, item ) ->
    icon = if item.icon? then item.icon else 'asterisk'
    label = if item.label? then item.label else ''
    li = $ """
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"
              role="button" aria-haspopup="true" aria-expanded="false">
            #{label} <span class="glyphicon glyphicon-#{icon}"
                aria-hidden="true"></span>
          </a>
        </li>
      """
    if item.items?.length
      ul = this._addMenu li, item
      ul.addClass 'multi-level'
    dom.append li

  _addMenu: ( dom, item ) ->
    dropdown = $ """<ul></ul>"""
    dropdown.addClass 'dropdown-menu'
    this._addMenuItems dropdown, item.items
    dom.append dropdown
    dropdown

  _addMenuItems: ( dom, items ) ->
    for item in items
      iType = if item.type? then item.type \
        else if item.href? then 'link' \
        else if item.label? then 'leaf' \
        else 'separator'
      href = if item.href? then item.href else '#'
      if iType == 'separator'
        li = $ '<li role="separator" class="divider"></li>'
      else if iType == 'header'
        li = $ """<li class="dropdown-header">#{item.label}</li>"""
      else
        if item.items?.length
          li = $ """<li class="item-#{iType} dropdown-submenu pull-right">
                        <a class="dropdown-toggle" data-toggle="dropdown"
                                    href="#{href}">#{item.label}</a></li>"""
          this._addMenu li, item
        else
          li = $ """<li class="item-#{iType}">
                        <a href="#{href}">#{item.label}</a></li>"""
      if item.click?
        li.find('a').click item.click
      dom.append li



$.widget 'custom.anchorsPage',
  _create: ->
    unless this.element.hasClass 'container'
      this.element.addClass 'container'


$.widget 'custom.styleSelector',
  _create: ->
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


$.fn.tilda = ( ev, options) ->
  if ($('body').data('tilda'))
    return $('body').data('tilda').terminal
  this.addClass('tilda')
  options = options || {}
  ev = ev || (command, term) ->
    term.echo("you don't set eval for tilda")
  settings =
    prompt: 'sf> ',
    name: 'tilda',
    enabled: false,
    height: 400
    greetings: 'Sitefile',
    keypress: (e) ->
      if (e.which == 96)
        return false
  if (options)
    $.extend settings, options
  td = '<div class="td"></div>'
  this.append td
  term = $(this).terminal ev, settings
  self = this
  focus = false
  $(document.documentElement).keypress (e) ->
    if (e.charCode == 96)
      self.slideToggle 'fast'
      # XXX: term.command_line.set ''
      term.focus focus = !focus
  $('body').data 'tilda', this
  this.hide()
  self


#module.export = {}


