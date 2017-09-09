define 'sf-v0/mixin.du-page', [

  'jquery'
  'jquery-ui'
  'css!/vendor/jquery-ui'
  'css!/media/style/default'
  'cs!../dhtml/jquery-sf-dupage'

], ( $ ) ->


  DocutilsPage:
    includes:
      ready: [ 'init_document' ]

    init_document: ->
      @document = @container.children '.document'
      unless @document.length
        @document = $ '<div class="document"><hr/></div>'
        @container.append @document

      du = $('.document').duPage()
      require [
        'cs!./dhtml/jquery-sf-proc'
        'cs!./dhtml/jquery-sf-anchorspage'
        'cs!./dhtml/jquery-sf-menu'
        'cs!./dhtml/jquery-sf-styleselector'
      ], ->

        anchors = $('.document').anchorsPage()

        $('.document').proc()

        navBar = $('body').navMenu()
        #navBar.mouseleave ->
        #  $(".dropdown").removeClass("open")

        nav = navBar.container()

        title = $('title').text()
        if title.split('-')[1]
          navBar.addTitle title.split('-')[1]

        $.ajax '/menu-sites.json',
          success: ( data, jqXhr ) ->
            nav.navMenuDropdown align: 'left', data: data, class: 'menu-sites'
            #if title.split('-')[1]
            navBar.addTitle title.split('-')[0]
            #nav.navMenuDropdown align: 'left', data:
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
                label: "Dev"
                type: "header"
              ,
                label: "jQuery Terminal"
                click: -> term.show()
              ]
            for x in data.items
              nav.navMenuDropdown align: 'right', data: x, class: 'menu-global'

          error: ->
            console.error 'error loading menu.json', arguments

      @app.events.ready.emit name: 'du-page', instance: @
