define 'sf-v0/mixin.breadcrumb', [

  'jquery'

], ( $ ) ->


  DocumentBreadcrumb:

    init_breadcrumb: ( path = window.location.href ) ->

      if not $('ol.breadcrumb').length
        location_ol = $ '<ol class="breadcrumb"/>'
        paths = path.split /[\/#]/
        depth = paths.length
        while paths.length
          path = paths.join('/')
          el = paths.pop()
          li = $ '<li/>'
          if !el
            if paths.length
              li.addClass "default"
            else
              li.addClass "root"
          if depth > paths.length+1
            li.addClass "directory"
            dir_ref = $ '<a/>'
            dir_ref.attr 'href', path
            dir_ref.append el
            li.append dir_ref
          else
            li.addClass "file"
            li.append el
          li.prependTo location_ol

        $('.header').prepend location_ol

      # coffeelint: disable=max_line_length
      location_edit = $ '<span class="edit-breadcrumb"><input class="form-control" id="breadcrumb"/>/</span>'
      # coffeelint: enable=max_line_length

      $('ol.breadcrumb li').click ( evt ) ->
        
        if $(evt.target).hasClass 'root'
          # TODO: move autocomplete here
          window.location.href = '/main'
        else
          evt.target.style.display = 'none'
          $(evt.target).before location_edit

          location_input = $('input#breadcrumb')
          location_input.attr 'value', evt.target.innerText
          location_input.focus()

          location_input.blur ->
            evt.target.innerText = location_input.val()
            evt.target.style.display = 'inline'
            location_edit.remove()
            check_location()

    check_location: ->
      path = @get_path()
      if window.location.pathname != path
        window.location.pathname = path

    get_path: ->
      path = []
      for el in $('ol.breadcrumb > li').get()
        path.push el.innerText
      path.join "/"




