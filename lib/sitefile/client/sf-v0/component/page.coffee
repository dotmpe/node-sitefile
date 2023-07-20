###
XXX: Place components, reading from ...
###
define 'sf-v0/component/page', [

  'cs!../component'
  'cs!./window'
  'lodash'
  'jquery'

  'cs!../profiles'
  'cs!../menu'

], ( Component, Window, _, $ ) ->


  class PageComponent extends Component

    constructor: ->
      super()

    start: ( meta ) ->

    @place: ->

  $(document).ready ( $ ) ->
    new PageComponent


  PageComponent

#
