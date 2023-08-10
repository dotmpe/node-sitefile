define 'sf-v0/page', [ 'lodash',

  # Document is a composite that includes the page's features as mixins to the
  # DocumentPage export
  'cs!sf-v0/document',

  # XXX: another unused Sf module. Move to jQ/DHTML?
  'cs!sf-v0/toggle-style',

  'crossroads', # Unused dependency for client-side routing
  'hasher', # access to hash-location navigation triggers/events
  'jquery-ui', # unused jQuery widgets dep
  'cookies-js' # initial try at persisting data per client

  'cs!./component/page'

], ( _, DocumentPage, ToggleStyle, crossroads, hasher, jqui, cookies ) ->


  console.log 'Loading Sitefile Page'

  class SitefilePage extends DocumentPage

    constructor: ( @app, @container=$('body'), @options = {} ) ->
      super @container, @options
      self = @ ; @app.page = @
      @app.events.ready.addListener ( evt ) ->
        if evt.name is 'du-page'
          self.init_sfpage_html()

    init_sfpage_html: ->
      $('.document', @container).addClass 'container'
      # TODO: apply based on html meta-data profile, see also dhtml.coffee
      profileUrl = $('html').attr('profile')
      if profileUrl == "http://dotmpe.com/project/sitefile"
        $('meta[name="sitefile.main"]').attr('content')
      # sanity check
      doc = @container.children '.document'
      if not doc.length
        throw new Error "Not a document page"

      #@du = new DocumentPage @container, @options
      @init_options()

      if @options.search
        # FIXME: new app/document layout
        nav = $ """
          <nav class="navbar navbar-default navbar-fixed-top" id="undefined">
            <div class="container-fluid">
              <div class="collapse navbar-collapse">
                <!--
                <form id="search" class="form-inline navbar-form ">
                  <input class="form-control mr-sm-2"
                      type="text" placeholder="Search">
                  <button class="btn btn-outline-success my-2 my-sm-0"
                      type="submit">Search</button>
                </form>-->
              </div>
            </div>
          </nav>"""
        $('body').prepend nav
        unless $( '#search' ).length
          @add_search 'body > .header'
        @init_search()

      if @options.hnav
        # FIXME @add_dates()
        @add_history_nav()

      else if @options.margin
        @add_margins()

      @init_router()
      @app.events.ready.emit name: 'sf-page', instance: @

    init_options: ->
      opts = cookies.get 'sf-v0', {}
      _.defaultsDeep @options, opts,
        search:
          source: "/Sitefile/core/auto"
        breadcrumb: true
        hnav: false
        margin: false

    add_search: ( c ) ->
      x=$ '<div id="search">'+
        '<input class="form-control" placeholder="Search"/></div>'
      $(c).append x
      console.log "Added search DOM"

    init_search: ->
      placeholder = $ '#search'
      if not placeholder.length
        console.warn "Search requires placeholder"
        return

      self = @
      $( "#search .form-control" ).autocomplete
        source: @options.search.source
        select: ( evt, ui ) ->
          hasher.setHash ui.item.label.substr 1
        close: ( evt, ui ) ->
          this.value = ""

    # coffeelint: disable=max_line_length
    add_margins: ->

      margin_left = $ '<div class="margin left"/>'
      margin_left.prependTo '.document'
      margin_right = $ '<div class="margin right">Margin Right</div>'
      margin_right.prependTo '.document'

      gutter_left = $ '<div class="gutter left">Gutter Left <a class="history-rev">Rev</a></div>'
      gutter_left.insertBefore '.document'
      gutter_right = $ '<div class="gutter right">Gutter Right <a class="history-fwd">Fwd</a></div>'
      gutter_right.insertBefore '.document'


    add_history_nav: ->

      margin_history_rev = $ '<div class="margin left"/>'
      ###
      margin_history_rev.html('
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
        Left Margin<br/>
      ')
      ###
      margin_history_rev.prependTo '.document'
      margin_history_fwd = $ '<div class="margin right">Margin Right</div>'
      margin_history_fwd.prependTo '.document'


      history_rev = $ '<div class="gutter left">Gutter Left <a class="history-rev">Rev</a></div>'
      history_rev.insertBefore '.document'
      history_fwd = $ '<div class="gutter right">Gutter Right <a class="history-fwd">Fwd</a></div>'
      history_fwd.insertBefore '.document'

    # coffeelint: enable=max_line_length

  SitefilePage: SitefilePage
  DocumentPage: DocumentPage

	# Object for RequireApp
  init_client_module: ( ready_cb, require_app ) ->
    page = new SitefilePage require_app, $('body'), {}
    require_app.events.ready.addListener ( evt ) ->
      if evt.name is 'sf-page'
        ready_cb( page )
    page
