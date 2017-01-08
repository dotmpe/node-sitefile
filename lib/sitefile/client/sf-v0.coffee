define 'sf-v0', [

  'jquery',
  'cs!sitefile/page',
  'cs!console',

  # 'cs!webcomp'

], ( $, SitefilePage, csl ) ->


  console.debug 'sf-v0 rjs loading'

  $(document).ready ( $ ) ->
    console.debug "sitefile page loaded"

    new SitefilePage()

    console.info "Sitefile page initialized"
    console.warn "Sitefile page initialized"
    console.log csl, csl.logs

