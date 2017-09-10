define 'sf-v0/mixin.last-modified', [

  'jquery'
  'css!./mixin.last-modified.sass'

], ( $ ) ->


  DocumentLastModified:

    ###
    On page load, add a date-time to the footer, using as value the
    first field found and not empty for the list of HTTP headers.
    ###

    includes:
      ready: [ 'add_date' ]

    # Scan these headers and in this sequence
    headers: [ 'last-modified', 'date' ]

    # Map header to string to use for class attribute
    classes:
      date: 'date server-time'
      'last-modified': 'date last-modified'

    add_date: ( path = window.location.href ) ->
      self = @
      $.ajax(
        type: 'HEAD'
        url: path
        data: {}
        success: (data, textStatus, request) ->
          klass = null; date = null
          for hd in self.headers
            date = request.getResponseHeader(hd)
            if date
              klass = self.classes[hd]
              date_span = $ "<span class=\"resource #{klass} date\"/> "
              date_span.append(date)

              $('.footer').append date_span
              break

        error: (request, textStatus, errorThrown) ->
          console.warn errorThrown
      )
