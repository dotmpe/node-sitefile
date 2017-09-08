###

###
define 'sf-v0/code', [

  'cs!./component'
  'lodash'
  'jquery'

], ( Component, _, $ ) ->


  class CodeComponent extends Component

    constructor: ( done, @app ) ->
      super()
      console.log 'CodeComponent', @
      @app.events.ready.addListener ( evt ) ->
        console.log 'ready', evt.name
        if evt.name is 'sf-page'
          done()
