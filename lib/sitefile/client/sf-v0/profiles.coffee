define 'sf-v0/profiles', [ 'lodash', 'jquery',

], ( _, $ ) ->


  SF_HTD = 'http://wtwta.org/_/HTD:microformat#sf-htd'
  SF_V0 = 'http://wtwta.org/project/sitefile#base:v0'


  profiles =
    'sf-htd': SF_HTD
    'sf-v0': SF_V0

  bootstrap_requirejs = ->
    requirejs.config
      main: 'cs!'
      map: {}
      paths: {}
      baseUrl: ''


  profile_handlers = 'sf-v0': {}
  profile_handlers['sf-v0']['bootstrap'] = ''
  profile_handlers['sf-v0']['controller'] = ''

  find_profile = ( uri ) ->
    for id of profiles
      if profiles[id] == uri
        return id

  load_profile = ( root, uri ) ->
    ns_id = find_profile uri
    console.log 'Found profile: ', uri, ns_id,
      'with available handlers: ', profile_handlers[ns_id]
    # TODO profile_handlers[ns_id][''] init

  load_profiles = ( profiles_ ) ->
    # Initialize based on profiles
    # TODO: but how to map to microformats exactly?
    bind_sets = $('*[profile]')
    for it in bind_sets
      uris = $(it).attr('profile').split(' ')
      for uri in uris
        profiles_.push [ it, uri ]
    if profiles
      for [ at, uri ] in profiles_
        load_profile at, uri

  $(document).ready -> ( $ ) ->
    window.sf = sf =
      page: profiles: [
          [ $('html'), SF_HTD ],
        ]
    load_profiles( sf.page.profiles )

  null

