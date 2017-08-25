define 'sf-v0/meta/nav', [

  'jquery'
  'underscore'
  'hasher'
  'bluebird'

], ( $, _, hasher ) ->


  dirname = ( str ) ->
    str = new String(str)
    str.substring 0, str.lastIndexOf('/')

  basename = ( str ) ->
    str = new String(str)
    base = str.substring str.lastIndexOf('/') + 1
    if -1 is not base.lastIndexOf "."
      base = base.substring 0, base.lastIndexOf "."
    base

  class NavMeta

    # Leaf and extension name to use for discovering JSON API
    json_api_dir: 'index'
    json_api_ext: 'api'

    ###
    Return full URL path
    ###
    resolve: ( ref, baseref ) ->
      if ref.substr(0,1) == '#'
        return baseref+ref
      if ref.substr(0,1) == '/'
        return ref
      # FIXME: catch all URL types
      if ref.substr(0,4) == 'http'
        return ref
      baseref = dirname(baseref)
      if baseref != '/'
        baseref = baseref+'/'
      return baseref+ref
    
    route: ( ref, baseref ) ->

    head: ( ) ->


    discover: ->
      baseref = window.location.pathname
      @discover_bottom_up baseref
      #@discover_top_down baseref

    discover_top_down: ( ref ) ->
      
    discover_bottom_up: ( ref ) ->
      self = @
      new Promise ( resolve, reject ) ->
        $.get(
          url: "#{ref}.#{self.json_api_ext}"
          complete: resolve
          error: reject
        )
      .then ( data ) ->
        console.log 'data', data
      .catch ( err ) ->
        dirref = dirname ref.replace /~+$/,''
        unless ref.substr(ref.length-1) is '/'
          if self.json_api_dir is basename ref
            if dirref
              pdirref = dirname dirref
              self.discover_bottom_up "#{pdirref}/#{self.json_api_dir}"
            else
              self.discover_bottom_up "#{dirref}/"
          else
            self.discover_bottom_up "#{dirref}/#{self.json_api_dir}"
        else
          console.log 'no API endpoint', ref

