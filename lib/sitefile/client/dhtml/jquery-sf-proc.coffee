
$.widget 'sitefile.proc',
  _create: ->
    this.document.children(".proc.pid").each ( idx, el ) ->
      procid = $(el).data('proc-id')
      $(el).empty().append $("<a>#{procid}</a>").attr href: '/proc/'+procid

