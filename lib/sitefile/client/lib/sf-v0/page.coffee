define 'sf-v0/page', [

  'lodash',
  #'underscore',
  'cs!sf-v0/document',
  'cs!sf-v0/togglescript',

  'crossroads',
  'hasher',
  'jqueryui',
  'cookies-js'


], ( _, DocumentPage, ToggleScript, crossroads, hasher, jqui, cookies ) ->


  # coffeelint: disable=max_line_length
  #bootstrap_glyphicons = require('../../../node_modules/bootstrap/dist/fonts/glyphicons-halflings-regular.woff');
  #bootstrap_glyphicons = require('../../../node_modules/bootstrap/dist/fonts/glyphicons-halflings-regular.ttf');
  # coffeelint: enable=max_line_length

  class SitefilePage extends DocumentPage

    constructor: ( @container=$('body'), @options = {} ) ->
      super @container, @options

      $('.document', @container).addClass 'container'

      # TODO: apply based on html meta-data profile

      profileUrl = $('html').attr('profile')

      if profileUrl == "http://dotmpe.com/project/sitefile"
        $('meta[name="sitefile.main"]').attr('content')

      doc = @container.children '.document'
      if not doc.length
        throw new Error "Not a document page"

      #@du = new DocumentPage @container, @options
      @init_options()

      if @options.search
        @add_search()

      if @options.breadcrumb
        @init_breadcrumb()

      if @options.hnav
        # FIXME @add_dates()
        @add_history_nav()

      else if @options.margin
        @add_margins()

      @init_router()

    init_options: ->
      opts = cookies.get 'sf-v0', {}
      _.defaultsDeep @options, opts,
        search:
          source: "/Sitefile/core/auto"
        breadcrumb: true
        hnav: false
        margin: false


    # coffeelint: disable=max_line_length

    add_search: ->
      
      if not $('.header hr').length
        throw new Error("Search requires Page Header")
      
      search_div = $ '<input id="search" class="form-control" placeholder="Search" style="width: 7em;padding-right: .5em; text-align: right"/>'

      $('.header hr').before search_div

      self = @
      $( "#search" ).autocomplete
        source: @options.search.source
        select: ( evt, ui ) ->
          hasher.setHash ui.item.label.substr 1
        close: ( evt, ui ) ->
          this.value = ""


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

