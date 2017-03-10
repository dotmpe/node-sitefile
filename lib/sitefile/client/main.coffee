
$(document).ready ->

  window.sf = sf =
    page: {}

  sf.page.du = $('.document').duPage()
  sf.page.anchors = $('.document').anchorsPage()

  sf.nav = $('.epilogue').navMenu()

  try
    $('.epilogue').prepend $ '<div id="tilda"></div> '
    sf.term = $('#tilda').tilda()
  catch e
    console.error "Failed initalizing Sitefile-Main Tilda", e

  $.ajax '/menu-sites.json',
    success: ( data, jqXhr ) ->
      sf.nav.navMenuDropdown align: 'left', data: data
      #sf.nav.navMenuDropdown align: 'left', data:
      #  icon: 'star'
      #  label: "Bookmarks"
      #  items: [
      #  ]

  $.ajax '/menu.json',
    success: ( data, jqXhr ) ->
      data.items[0].items[0].items.unshift
        label: 'Page'
        items: [
          label: "Style selector"
          click: ->
            $('.header').styleSelector()
        ,
          type: "separator"
        ,
          label : "Dev"
          type: "header"
        ,
          label: "jQuery Terminal"
          click: -> term.show()
        ]
      for x in data.items
        sf.nav.navMenuDropdown align: 'right', data: x

    error: ->
      console.error 'error loading menu.json', arguments

