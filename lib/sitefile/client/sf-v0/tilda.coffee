define 'sf-v0/tilda', [

  'jquery'
	'jquery-terminal'
 'css!/vendor/jquery-terminal'
 'css!/media/style/jquery-terminal-animated-cursor'

], ( $ ) ->

  require [ 'cs!./dhtml/jquery-sf-tilda' ], ->

    $(document).ready ->

      if not $('#tilda').length
        if $('.epilogue').length
          $('.epilogue').prepend $ '<div id="tilda"></div> '
        else
          return

      console.log 'Initializing Tilda'

      try
        sf.term = $('#tilda').tilda()
      catch e
        console.error "Failed initalizing Sitefile-Main Tilda", e

  null

