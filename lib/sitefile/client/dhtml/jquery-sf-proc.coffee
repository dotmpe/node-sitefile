
$.widget 'sitefile.proc',
  _create: ->
    this.document.children(".proc.pid").each ( idx, el ) ->
      # Clear element, replace with hyperlink
      procid = $(el).data('proc-id')
      $(el).empty().append $("<a>#{procid}</a>").attr href: '/proc/'+procid

