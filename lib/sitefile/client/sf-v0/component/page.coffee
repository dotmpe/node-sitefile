###
XXX: Place components, reading from ...
###
define 'sf-v0/component/page', [

  'cs!../component'
  'lodash'
  'jquery'

  'cs!../profiles'
  'cs!../menu'

], ( Component, _, $ ) ->


  class PageComponent extends Component

    constructor: ->
      super()
      meta = $('meta[name=sitefile-client-meta]').attr 'content'
      #unless meta then meta = window.location.pathname+'/base'
      #$.getJSON meta, _.bind @start, @

    start: ( meta ) ->
      console.log 'meta', meta

    @place: ->

  $(document).ready ( $ ) ->
    new PageComponent


  PageComponent

