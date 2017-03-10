

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


$.fn.navMenu = ( ev, options ) ->
  settings = $.extend {
    align: 'left'
    data: {}
  }, options
  navId = settings.data.id
  nav = $ 'nav#'+navId
  el = this
  navMenu =
    _initNavMenu: ->
      unless nav.length
        nav = $ """
          <nav class="navbar navbar-default navbar-fixed-top" id="#{navId}">
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



$.widget 'dotmpe.anchorsPage',
  _create: ->
    unless this.element.hasClass 'container'
      this.element.addClass 'container'
    # TODO: clickable, linked anchors, ID's


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


# TODO: fix deployment for interpreter
terminalInterpreter = (command, term) ->
  cmd = $.terminal.parse_command command
  if command.match /![*$]|\s*!!(:p)?\s*$|\s*!(.*)/
    new_command
    history = term.history()
    last = $.terminal.parse_command history.last()
    match = command.match /\s*!(?![!$*])(.*)/
    if match
      re = new RegExp $.terminal.escape_regex match[1]
      history_data = history.data()
      for v in history_data
        if re.test v
          new_command = v
          break
      if (!new_command)
        msg = $.terminal.defaults.strings.commandNotFound
        term.error(sprintf(msg, $.terminal.escape_brackets(match[1])))
    else if command.match /![*$]/
      if (last.args.length)
        last_arg = last.args[last.args.length-1]
        new_command = command.replace(/!\$/g, last_arg)
      new_command = new_command.replace(/!\*/g, last.rest)
    else if (command.match(/\s*!!(:p)?/))
      new_command = last.command
    if (new_command)
      term.echo(new_command)
    if !command.match /![*$!]:p/
      if new_command
        term.exec new_command, true
  else if cmd.name in "ls dir less more cat parseurl url man".split ' '
    term.error "Sorry, not yet!"
  else if cmd.name == 'help'
    term.echo "built-in commands: echo help"
    term.echo "other queries are evaluated as javascript"
  else if cmd.name == 'echo'
    term.echo cmd.rest
  else
    if 'js' == command.substr 0, 2
      command = command.substr 3
    cmdr = eval command
    if typeof cmdr == 'string'
      term.echo cmdr
    else if typeof cmdr == 'object'
      term.echo JSON.stringify cmdr
    else
      term.echo typeof cmdr


$.widget 'jquery-terminal.tilda',
  options:
    align: 'left'
    data: {}
    eval: terminalInterpreter
    prompt: 'sf> ',
    name: 'sf-tilda',
    enabled: false,
    height: 400
    greetings: 'Sitefile Client',
    keypress: (e) ->
      if (e.which == 96)
        return false
    # we need to disable history for bash history commands
    historyFilter: (command) ->
      !command.match /![*$]|\s*!!(:p)?\s*$|\s*!(.*)/
  _create: ->
    @element.addClass('tilda')
    td = '<div class="td"></div>'
    @element.append td
    term = @element.terminal @options.eval, @options
    focus = false
    $(document.documentElement).keypress (e) ->
      if (e.charCode == 96)
        term.slideToggle 'fast'
        # XXX: term.command_line.set ''
        term.focus focus = !focus
    term.hide()
    term


#module.export = {}

