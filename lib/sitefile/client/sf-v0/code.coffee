###

A Jupyter-like widget, for local Sh scripts initially.

Other ideas: vm/container wrappers with exec envs.

###
define 'sf-v0/code', [

  'cs!./component/microformat'
  'lodash'
  'jquery'

  'text!./code.pug.html'
  'text!./code-tools.pug.html'

  'css!./code.sass'
  'css!/vendor/font-awesome'

], ( Microformat, _, $, tpl, toolsTpl ) ->


  class CodeComponent extends Microformat

    name: 'local execute microformat'
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
      self = @ ; cmd = @$el.text()
      @$el.find('.btn.start').click ->
        self.start idx, endpoint, cmd

      rs = $("""
              <div class="sf-mf sf-code-result">
                <pre class="warnings alert-warning"/>
                <pre class="output"/>
              </pre>
            """)
      @blocks[idx] =
        code: @$el
        result: rs.find '.output'
        warnings: rs.find '.warnings'
      @$el.after rs

    start: ( idx, endpoint, cmd ) ->
      self = @
      $.get
        url: @options.endpoints[endpoint]+'?cmd='+encodeURI cmd
        error: ( err ) ->
          if err.responseJSON.stdout
            self.blocks[idx].result.html err.responseJSON.stdout
            self.blocks[idx].result.show()
          else
            self.blocks[idx].result.hide()
          self.blocks[idx].warnings.show()
          self.blocks[idx].warnings.addClass 'alert-danger'
          if err.responseJSON.stderr
            self.blocks[idx].warnings.html err.responseJSON.stderr
          else
            self.blocks[idx].warnings.html arguments[2]
        success: ( data ) ->
          self.blocks[idx].result.show()
          self.blocks[idx].result.html data.stdout
          if data.stderr
            self.blocks[idx].warnings.html data.stderr
            self.blocks[idx].warnings.show()
            self.blocks[idx].warnings.removeClass 'alert-danger'
          else
            self.blocks[idx].warnings.html ''
            self.blocks[idx].warnings.hide()
