
$(document).ready ->

  window.sf = sf =
    page: {}

  sf.page.du = $('.document').duPage()
  sf.page.anchors = $('.document').anchorsPage()

  navBar = $('.epilogue').navMenu()
  sf.nav = navBar.container()

  title = $('title').text()
  navBar.addTitle title.split('-')[0]

  try
    $('.epilogue').prepend $ '<div id="tilda"></div> '
    sf.term = $('#tilda').tilda()
  catch e
    console.error "Failed initalizing Sitefile-Main Tilda", e

  $.ajax '/menu-sites.json',
    success: ( data, jqXhr ) ->
      sf.nav.navMenuDropdown align: 'left', data: data, class: 'menu-sites'
      if title.split('-')[1]
        navBar.addTitle title.split('-')[1]
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
        sf.nav.navMenuDropdown align: 'right', data: x, class: 'menu-global'

    error: ->
      console.error 'error loading menu.json', arguments

