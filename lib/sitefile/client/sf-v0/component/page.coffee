###
Place components, reading from 
###
define 'sf-v0/component/page', [

  'cs!../component'
  'lodash'
  'jquery'

], ( Component, _, $ ) ->


  class PageComponent extends Component

    constructor: ->
      super()
      meta = $('meta[name=sitefile-client-meta]').attr 'content'
      unless meta then meta = window.location.pathname+'/base'
      $.getJSON meta, _.bind @start, @

    start: ( meta ) ->
      console.log 'meta', meta

    @place: ->

  class Layout extends PageComponent
  class View extends PageComponent
  class Field extends PageComponent

  $(document).ready ( $ ) ->
    new PageComponent


  PageComponent

