
profiles = {
  'sf-v0': 'http://schema.wtwta.org/_/htd-microformats#sfv0'
}

profile_handlers = {'sf-v0':{}}
profile_handlers['sf-v0']['bootstrap'] = ''
profile_handlers['sf-v0']['controller'] = ''

find_profile = ( uri ) ->
  for id of profiles
    if profiles[id] == uri
      return id
  
load_profile = ( root, uri ) ->
  ns_id = find_profile uri
  console.log uri, ns_id, profile_handlers[ns_id]
  profile_handlers[ns_id]

load_profiles = ( profiles_ ) ->
  # Initialize based on profiles
  # TODO: but how to map to microformats exactly?
  bind_sets = $('*[profile]')
  for it in bind_sets
    uris = it.attr('profile').split(' ')
    for uri in uris
      profiles_.append [ it, uri ] 
  if profiles
    for [ at, uri ] in profiles_
      load_profile at, uri

$(document).ready ->
  window.sf = sf =
    page: profiles: [
        [ $('html'), 'http://schema.wtwta.org/_/htd-microformats#sfv0' ],
      ]
  load_profiles( sf.page.profiles )

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

