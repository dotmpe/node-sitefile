define 'sf-v0/tilda', [

  'jquery'
  'jquery-terminal'
  'css!/vendor/jquery-terminal'

], ( $ ) ->


  class TildaClientModule

    constructor: ( ready, loader ) ->

      loader.events.ready.addListener ({ name }) ->

        # Wait for SitefilePage to load
        if name != 'cs!sf-v0/page'
          return

        require [
          'cs!./dhtml/jquery-sf-tilda'
          'css!./dhtml/jquery-sf-tilda.sass'
        ], ->

          console.log 'Tilda DHTML included'
          if not $('#tilda').length
            if $('.epilogue').length
              $('.epilogue').prepend $ '<div id="tilda"></div> '
            else
              console.log 'Nothing to init tilda from'
              return

          console.log 'Initializing Tilda'
          try
            term = $('#tilda').tilda()
          catch e
            console.error "Failed initalizing Sitefile-Main Tilda", e

      ready()
