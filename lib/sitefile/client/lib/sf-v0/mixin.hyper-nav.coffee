define 'sf-v0/mixin.hyper-nav', [

  'jquery',
  'underscore',

], ( $, _ ) ->


  HNavDocument:

    init_placeholder: (cb) ->
      $(".placeholder").on "click", "a", (e) ->
        cb '/'+$(this).attr "href"
        e.preventDefault()
      $('ol.breadcrumb').remove()
      @init_breadcrumb()


