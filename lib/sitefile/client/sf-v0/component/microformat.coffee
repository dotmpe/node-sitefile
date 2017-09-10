#
# Microformats are `attach`'ed on the sf-page ready event,
# for each element found given a certain CSS selector.
#
define 'sf-v0/component/microformat', [

  'cs!../component'
  'lodash'
  'jquery'

], ( Component, _, $ ) ->


  class Microformat extends Component

    constructor: ( done, @app ) ->
      super()
      self = @
      @app.events.ready.addListener ( evt ) ->
        if evt.name is 'sf-page'
          console.log 'Microformat', self.name, evt.name
          evt.instance.app.events.init.emit name: @name, instance: @
          $(self.selector).each ( idx, el ) ->
            self.$el = $(el)
            self.attach idx, el
          evt.instance.app.events.ready.emit name: @name, instance: @
      done()
