define 'sf-v0/mixin.hyper-nav', [

  'jquery',
  'underscore',
  'hasher'

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


  HNavDocument:
    # HNav rewrites all links to fetch a document fragment and put it in
    # '.placeholder'. Content links can use '#sf:xref'

    init_placeholder: ( homeref, self=@ ) ->

      # Rewrite page's A hrefs and IMG src's to new home
      @init_placeholder_a_href homeref, self
      @init_placeholder_img_src homeref, self

      # Use breadcrumb if mixed in
      if 'init_breadcrumb' in @
        $('ol.breadcrumb').remove()
        @init_breadcrumb()

    # Update image src attribute while embedded at another base
    init_placeholder_img_src: ( homeref, self=@ ) ->
      $(".placeholder img").each ->
        ref = self.resolve_pageref $(this).attr("src"), homeref
        $(this).attr "src", ref

    # Update a href onclick for embedded use
    init_placeholder_a_href: ( homeref, self=@ ) ->
      $(".placeholder").on "click", "a", (evt) ->
        evt.preventDefault()
        ref = self.resolve_pageref $(this).attr("href"), homeref
        console.log 'href onclick', $(this).attr("href"), ref, homeref
        if '/' == ref.substr 0, 1
          hasher.setHash ref.substr 1
        else
          hasher.setHash ref
        return true

    init_router: ( self=@ ) ->
      # setup crossroads
      #crossroads.addRoute 'foo'
      #crossroads.addRoute 'lorem/ipsum'
      #crossroads.routed.add(console.log, console) # log all routes

      # setup hasher
      parseHash = ( newHash, oldHash) ->
        if '/' != newHash.substr 0, 1
          unless newHash.substr(0,4) == 'http'
            newHash = '/'+newHash
        if oldHash and '/' != oldHash.substr 0, 1
          # FIXME: catch all URL types
          unless oldHash.substr(0,4) == 'http'
            oldHash = '/'+oldHash
        console.log 'parseHash to', newHash, ' from ', oldHash
        self.route_page newHash, oldHash

      hasher.initialized.add(parseHash) # parse initial hash
      hasher.changed.add(parseHash) # parse hash changes
      hasher.init() # start listening for history change

      # update URL fragment generating new history record
      #hasher.setHash window.location.hash

    resolve_pageref: ( ref, baseref ) ->
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

    # Change content from URL self to cref, do HEAD on absolut URL ref
    # and load image or page.
    route_page: ( self, cref ) ->
      #console.log 'route_page A', @, ref, cref
      # Resolve reference
      ref = @resolve_pageref self, cref
      # Use proxied URL to bypass XHR CORS
      if ref.substr(0,1) != '/'
        ref = '/res/http?url='+ref
      # Do HEAD to determine content-type
      self = @
      jxr = $.ajax
        type: 'HEAD'
        async: true
        url: ref
        success: ->
          mt = jxr.getResponseHeader 'Content-Type'
          console.log 'resolved', mt, ref
          if mt.indexOf('image/') == 0
            self.resolve_img ref
          else if mt.indexOf('html') > -1
            self.resolve_page ref
          else
            console.log 'TODO', mt, ref

    resolve_img: ( href ) ->
      $('.placeholder').off 'click'
      img = $ '<img />'
      img.attr 'src', href
      $('.placeholder').html('').append img

    # Get body from HTTP URL. Unless the #sf:xref fragment is present.
    # Make jquery insert content at placeholder
    resolve_page: ( href ) ->
      # XXX: Clean listeners on element by dropping
      #$('.placeholder')
      #.replaceWith('<div class="container placeholder"></div>')
      $('.placeholder').off 'click'
      # Load content
      x = href.indexOf '#sf:xref:'
      if x == -1 && href.substr(0,4) == 'http'
        xref = '/res/http?url='+href+' body'
      else if x > -1
        xref = href.substr(0,x)+' '+decodeURI href.substr x+9
      else
        xref = href+' .document>*'
      # Use jQuery.load to get at content at other resource
      console.log "Loading xref #{xref}"
      self = @
      $('.placeholder').load xref, ( rsTxt, txtStat, jqXhr ) ->
        console.log xref, rsTxt
        if txtStat not in [ "success", "notmodified" ]
          console.log 'jQ.load fail, TODO', arguments
        else
          #mt = jqXhr.getResponseHeader 'Content-Type'
          console.log "Loaded", href
          self.init_placeholder href
          # Do our best to find a title/h1 text to use
          self.get_title rsTxt
          # Run scripts (if browser didn't strip them)
          self.run_scripts rsTxt
      #crossroads.parse newHash

    # TODO: use events instead and let client decide what to do on xref
    # content, what with title and wether to run scripts.

    set_title: ( title ) ->
      console.log "TODO: title", title

    get_title: ( html ) ->
      el = $.parseHTML html, true
      titles = $('title', el)
      if titles.length
        @set_title(titles.text())
      else
        titles = $('h1', el)
        if titles.length
          @set_title(titles.text())

    run_scripts: ( html ) ->
      el = $.parseHTML html, true
      $('script', el).each ->
        $.globalEval @text || @textContent || @innerHtml || ''
