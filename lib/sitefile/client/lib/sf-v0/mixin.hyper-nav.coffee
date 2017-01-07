define 'sf-v0/mixin.hyper-nav', [

  'jquery',
  'underscore',
  'hasher'

], ( $, _, hasher ) ->


  dirname = ( str ) ->
    new String(str).substring 0, str.lastIndexOf('/')
  baseName = ( str ) ->
    base = new String(str).substring str.lastIndexOf('/') + 1
    if -1 is not base.lastIndexOf "."
      base = base.substring 0, base.lastIndexOf "."
    base


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

    init_router: ( self=@ ) ->
      # setup crossroads
      #crossroads.addRoute 'foo'
      #crossroads.addRoute 'lorem/ipsum'
      #crossroads.routed.add(console.log, console) # log all routes

      # setup hasher
      parseHash = ( newHash, oldHash) ->
        if '/' != newHash.substr 0, 1
          newHash = '/'+newHash
        if oldHash and '/' != oldHash.substr 0, 1
          oldHash = '/'+oldHash
        console.log 'parseHash', newHash, oldHash
        self.route_page newHash, oldHash
        
      hasher.initialized.add(parseHash) # parse initial hash
      hasher.changed.add(parseHash) # parse hash changes
      hasher.init() # start listening for history change

      # update URL fragment generating new history record
      #hasher.setHash window.location.hash

    resolve_page:  ( ref, baseref ) ->
      if ref.substr(0,1) == '#'
        return baseref+ref
      if ref.substr(0,1) == '/'
        return ref
      if ref.substr(0,4) == 'http'
        return '/ref/'+ref
      baseref = dirname(baseref)
      if baseref != '/'
        baseref = baseref+'/'
      return baseref+ref

    route_page: ( ref, cref ) ->
      console.log 'route_page A', @, ref, cref
      ref = @resolve_page ref, cref
      console.log 'route_page B', @, ref, cref
      self = @
      # Clean listeners on element by dropping
      #$('.placeholder').replaceWith('<div class="container placeholder"></div>')
      $('.placeholder').off 'click'
      # Load content
      $('.placeholder').load ref+' .document > *', ( rsTxt, txtStat, jqXhr ) ->
        if txtStat not in [ "success", "notmodified" ]
          console.log 'jQ.load fail, TODO', arguments
        else
          console.log "Loaded", ref
          self.init_placeholder ref

      #crossroads.parse newHash


