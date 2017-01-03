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
        if '/' == ref.substr 0, 1
          hasher.setHash ref.substr 1
        else
          hasher.setHash ref
        return true
      $('ol.breadcrumb').remove()
      @init_breadcrumb()


