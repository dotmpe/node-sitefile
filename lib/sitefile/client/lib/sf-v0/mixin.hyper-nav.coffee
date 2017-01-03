define 'sf-v0/mixin.hyper-nav', [

  'jquery',
  'underscore',
  'hasher'

], ( $, _, hasher ) ->


  HNavDocument:

    init_placeholder: ( homeref, self=@ ) ->
      $(".placeholder").on "click", "a", (evt) ->
        evt.preventDefault()
        ref = self.resolve_page $(this).attr("href"), homeref
        console.log 'ref', $(this).attr("href"), ref, homeref
        hasher.setHash ref.substr 1
        return true
      $('ol.breadcrumb').remove()
      @init_breadcrumb()


