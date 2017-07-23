
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

