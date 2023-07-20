###
	Build CSS menu from items and groups
###
$.fn.navMenu = ( ev, options ) ->
  settings = $.extend {
    align: 'left'
    data: {}
    navBarStyle: 'navbar-fixed-top'
    #navBarStyle: 'navbar-static-top'
  }, options
  style = settings.navBarStyle
  navId = settings.data.id
  nav = $ 'nav#'+navId
  el = this
  navMenu =
    _initNavMenu: ->
      unless nav.length
        nav = $ """
          <nav class="navbar navbar-default #{style}" id="#{navId}">
            <div class="container-fluid">
              <div class="collapse navbar-collapse">
              </div>
            </div>
          </nav>"""
        el.prepend nav
    container: ->
      return nav.find '.collapse'
    addMenuDropdown: ( items ) ->
      for item in items
        navMenu.navMenuDropdown
          align: settings.align
          data: item
    addTitle: ( str ) ->
      title = $ """
          <a href="#" class="navbar-brand">#{str}</a>
        """
      navMenu.container().append title

  navMenu._initNavMenu()
  if settings.data.items
    navMenu.addMenuDropdown settings.data.items
  return navMenu


$.fn.navMenuDropdown = ( options ) ->
  settings = $.extend {
    prepend: false
    align: 'left'
    class: 'sf-nb-dd-menu'
    data: {}
  }, options
  navMenuDropdown =
    _addNavItem: ( dom, item ) ->
      menu = $ """
          <ul class="nav navbar-nav navbar-#{settings.align} #{settings.class}">
          </ul>
        """
      navMenuDropdown._addNavMenuItem menu, item
      if settings.prepend
        dom.prepend menu
      else
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
        ul = navMenuDropdown._addMenu li, item
        ul.addClass 'multi-level'
      dom.append li
    _addMenu: ( dom, item ) ->
      dropdown = $ """<ul></ul>"""
      dropdown.addClass 'dropdown-menu'
      navMenuDropdown._addMenuItems dropdown, item.items
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
            pull = if settings.align == 'left' then 'right' else 'left'
            li = $ """<li class="item-#{iType} dropdown-submenu pull-#{pull}">
                          <a class="dropdown-toggle" data-toggle="dropdown"
                                      href="#{href}">#{item.label}</a></li>"""
            navMenuDropdown._addMenu li, item
          else
            li = $ """<li class="item-#{iType}">
                          <a href="#{href}">#{item.label}</a></li>"""
        if item.click?
          li.find('a').click item.click
        dom.append li

  navMenuDropdown._addNavItem this, settings.data

  navMenuDropdown

