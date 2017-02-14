
$(document).ready ->

  $('.document').duPage()
  $('.document').anchorsPage()

  $.ajax '/menu-sites.json',
    success: ( data, jqXhr ) ->
      console.log data
      $('body').leftNavMenu data:
        id: 'sites'
        items: [
          data
        ]
  ###

  $.ajax '/menu.json',
    success: ( data, jqXhr ) ->
      data.items[0].items[0].items.unshift
        name: 'Page'
        items: [
          name: "Style selector"
          click: ->
            unless $('#style-selector').length
              div = $ '<div class="container" id="style-selector">
                  <div class="panel panel-default">
                    <div class="panel-heading clearfix">
                      <h3 class="panel-title pull-left">Style selector</h3>
                      <button type="button" class="pull-right close"
                          data-target="#style-selector"
                          data-dismiss="alert">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">Close</span>
                      </button>
                    </div>
                    <div class="panel-body">
                    </div>
                    <div class="panel-footer">
                    </div>
                  </div>
                </div>'
              $(div).find('.panel-body').styleSelector()
              $('.header').append div
        #,
        #  type: "separator"
        #,
        #  name : "Dev"
        #  type: "header"
        #,
        #  name: "jQuery Terminal"
        #  click: ->
        ]
      $('body').rightNavMenu data: data
      $('body').prepend $ '<div id="tilda"></div> '
      $('#tilda').tilda eval, {}


    error: ->
      console.error 'error loading menu.json', arguments
  ###

