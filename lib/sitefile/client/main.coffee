
$(document).ready ->

  window.sf = sf =
    page: {}

  sf.page.du = $('.document').duPage()
  sf.page.anchors = $('.document').anchorsPage()

  sf.nav = $('body').navMenu()

  $('body').prepend $ '<div id="tilda"></div> '
  sf.term = $('#tilda').tilda()

  $.ajax '/menu-sites.json',
    success: ( data, jqXhr ) ->
      sf.nav.navMenuDropdown align: 'left', data: data

  $.ajax '/menu.json',
    success: ( data, jqXhr ) ->
      ###
      data.items[0].items[0].items.unshift
        name: 'Page'
        items: [
          name: "Style selector"
          click: ->
            $('.header').styleSelector()
        #,
        #  type: "separator"
        #,
        #  name : "Dev"
        #  type: "header"
        #,
        #  name: "jQuery Terminal"
        #  click: ->
        ]
      ###
      sf.nav.navMenuDropdown align: 'right', data: data.items[0]

    error: ->
      console.error 'error loading menu.json', arguments

