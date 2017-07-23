define 'sf-v0/mixin.last-modified', [

  'jquery'

], ( $ ) ->


  DocumentLastModified:
    includes:
      ready: [ 'add_dates' ]

    add_dates: ( path = window.location.href ) ->
      $.ajax(
        type: 'POST'
        url: path
        data: {}
        success: (data, textStatus, request) ->
          lm = request.getResponseHeader('last-modified')
          if lm
            date = lm
          else
            date = request.getResponseHeader('date')

          date_span = $('<span class="date"/>')
          date_span.append(date)

          $('.footer').append date_span

        error: (request, textStatus, errorThrown) ->
          console.warn errorThrown
      )


