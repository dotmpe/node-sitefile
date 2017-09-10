#
# A Jupyter-like widget, for local Sh scripts initially.
#
# Other ideas: vm/container wrappers with exec envs.
#
define 'sf-v0/microformats/live-code', [

  'cs!../component/microformat'
  'lodash'
  'jquery'

  'text!./live-code.pug.html'
  'text!./live-code-tools.pug.html'
  'css!./live-code.sass'
  'css!/vendor/font-awesome'

], ( Microformat, _, $, tpl, toolsTpl ) ->


  class CodeComponent extends Microformat

    name: 'Live Code'
    description: 'Inline, locally executed code'
    selector: '.sf-mf.sf-code'
    options:
      endpoints:
        'mf-sh-cmd': '/sh/'

    attach: ( idx ) ->
      @toolsTpl = $.parseHTML toolsTpl
      for ep of @options.endpoints
        if @$el.hasClass ep
          @init idx, ep

    blocks: []

    init: ( idx, endpoint ) ->
      @$el.prepend @toolsTpl
      self = @
      @$el.find('.btn.start').click ->
        self.start idx, endpoint, self.blocks[idx].cmd

      rs = $("""
              <div class="sf-mf sf-code-result">
                <pre class="warnings alert-warning"/>
                <pre class="output"/>
              </pre>
            """)
      @blocks[idx] =
        code: @$el
        cmd: @$el.text()
        result: rs.find '.output'
        warnings: rs.find '.warnings'
      @$el.after rs

    set_result: ( idx, endpoint, data ) ->

      @blocks[idx].warnings.html data.stderr || ''
      @blocks[idx].result.html data.stdout || ''

      unless data.code?
        data.code = 0
      if data.code
        @blocks[idx].result.toggle not _.isEmpty data.stdout
        @blocks[idx].warnings.addClass 'alert-danger'
        @blocks[idx].warnings.show()

      else
        @blocks[idx].result.show()
        if data.stdout
          @blocks[idx].result.html data.stdout
        else
          @blocks[idx].result.html "(no output)"
        @blocks[idx].warnings.removeClass 'alert-danger'
        @blocks[idx].warnings.toggle not _.isEmpty data.stderr

    start: ( idx, endpoint, cmd ) ->
      self = @
      $.get
        url: @options.endpoints[endpoint]+'?cmd='+encodeURIComponent cmd
        error: ( err ) ->
          unless err.responseJSON.stderr
            err.responseJSON.stderr = arguments[2]
          self.set_result idx, endpoint, err.responseJSON
        success: ( data ) ->
          self.set_result idx, endpoint, data
