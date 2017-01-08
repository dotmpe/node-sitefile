define 'sf-v0', [

  'jquery',
  'cs!sitefile/page',

], ( $, SitefilePage ) ->


  console.log 'sf-v0 rjs loading'


  $(document).ready ( $ ) ->
    console.log "sitefile page loaded"

    new SitefilePage()

    console.log "Sitefile page initialized"


